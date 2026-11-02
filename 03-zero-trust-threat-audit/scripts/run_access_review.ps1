# =========================================================================
# PROJECT 3: AUTOMATED ZERO-TRUST IDENTITY COMPLIANCE ENGINE
# =========================================================================

$TenantId     = $env:AZURE_TENANT_ID
$ClientId     = $env:AZURE_CLIENT_ID
$ClientSecret = $env:AZURE_CLIENT_SECRET

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TokenUri = "https://microsoft.com"
$TokenBody = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "client_credentials"
    scope         = "https://microsoft.com"
}

Write-Host "[SECURITY] Contacting Microsoft Identity Platform via OAuth 2.0..." -ForegroundColor Cyan

try {
    # Execute the HTTP POST request to retrieve the short-lived Bearer Access Token
    $TokenResponse = Invoke-RestMethod -Method Post -Uri $TokenUri -ContentType "application/x-www-form-urlencoded" -Body $TokenBody
    $AccessToken   = $TokenResponse.access_token
    Write-Host "[AUTH] Secure OAuth 2.0 Bearer Token successfully generated." -ForegroundColor Green
} catch {
    # 🔥 THE FIX: Capture and display the exact, raw raw response from Microsoft
    Write-Host "`n[❌ HTTP EXCEPTION RECIEVED FROM MICROSOFT]" -ForegroundColor Red
    $RawError = $_.Exception.Response
    if ($RawError) {
        $ResponseStream = New-Object System.IO.StreamReader($RawError.GetResponseStream())
        $ErrorMessage = $ResponseStream.ReadToEnd()
        Write-Host "Raw Payload Error: $ErrorMessage" -ForegroundColor Yellow
    } else {
        Write-Host "System Exception Message: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    Exit 1
}


$Headers = @{
    "Authorization" = "Bearer $AccessToken"
    "Content-Type"  = "application/json"
}

$ComplianceThresholdDays = 90
$CutoffDate = (Get-Date).AddDays(-$ComplianceThresholdDays)
$FormattedCutoff = $CutoffDate.ToString("yyyy-MM-ddTHH:mm:ssZ")

$GraphUri = "https://microsoft.com?`$select=id,displayName,userPrincipalName,signInActivity,department"

Write-Host "[AUDIT] Ingesting cloud identity registry to evaluate Threat Surface..." -ForegroundColor Cyan

try {
    $UserRegistry = Invoke-RestMethod -Method Get -Uri $GraphUri -Headers $Headers
    $AllUsers     = $UserRegistry.value
} catch {
    Write-Error "[API ERROR] Failed to query user registry endpoints from Graph backend."
    Exit 1
}

Write-Host "`n=====================================================================" -ForegroundColor Yellow
Write-Host "         LIVE COMPLIANCE REPORT: ZERO-TRUST USER ACCESS AUDIT        " -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host "Compliance Deadline Cutoff: Accounts inactive since $FormattedCutoff must be flagged.`n" -ForegroundColor Gray

$StaleAccountCount = 0

foreach ($User in $AllUsers) {
    if ($User.userPrincipalName -match "admin" -or $User.displayName -match "Auditor") { continue }

    $LastSignIn = $User.signInActivity.lastSignInDateTime
    $UserUPN    = $User.userPrincipalName

    if ([string]::IsNullOrEmpty($LastSignIn)) {
        Write-Host "[STALE THREAT] USER: $($User.displayName) ($UserUPN) | DEPT: $($User.department)" -ForegroundColor Red
        Write-Host "  -> Detonation Factor: Account has NEVER logged into the platform since migration!" -ForegroundColor Gray
        $StaleAccountCount++
    } 
    else {
        $SignInDate = [DateTime]::Parse($LastSignIn)
        
        if ($SignInDate -lt $CutoffDate) {
            Write-Host "[STALE THREAT] USER: $($User.displayName) ($UserUPN) | DEPT: $($User.department)" -ForegroundColor Red
            Write-Host "  -> Detonation Factor: Last login was $LastSignIn (Over $ComplianceThresholdDays days ago)" -ForegroundColor Gray
            $StaleAccountCount++
        }
        else {
            Write-Host "[COMPLIANT] USER: $($User.displayName) ($UserUPN) | Active Access Verified." -ForegroundColor Green
        }
    }
}

Write-Host "`n=====================================================================" -ForegroundColor Yellow
if ($StaleAccountCount -gt 0) {
    Write-Host "[COMPLIANCE FAILED] Audit completed. Found $StaleAccountCount vulnerable, inactive account(s)." -ForegroundColor Red
} else {
    Write-Host "[SYSTEM CLEAN] Audit completed. 100% of managed identity nodes are compliant." -ForegroundColor Green
}
Write-Host "=====================================================================" -ForegroundColor Yellow
