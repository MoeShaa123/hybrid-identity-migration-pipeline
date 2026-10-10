# Define the project file paths
$csvPath = "../data/legacy_users.csv"
$jsonPath = "../data/identities.json"

# Read the legacy corporate database rows
$users = Import-Csv -Path $csvPath
$cloudIdentities = @()

foreach ($user in $users) {
    # Programmatically standardise names into a clean, lower-case cloud format
    $cleanFirstName = $user.FirstName.ToLower().Replace("'", "")
    $cleanLastName = $user.LastName.ToLower().Replace("'", "")
    
    # Establish a uniform cloud user login suffix
    $userPrincipalName = "$cleanFirstName.$cleanLastName@://onmicrosoft.com"
    
    # Structure the identity object to feed into the Terraform loops
    $identity = [PSCustomObject]@{
        FirstName         = $user.FirstName
        LastName          = $user.LastName
        Department        = $user.LegacyDepartment
        JobTitle          = $user.JobTitle
        UserPrincipalName = $userPrincipalName
    }
    $cloudIdentities += $identity
}

# Convert the identities array into a structured JSON string and save it
$cloudIdentities | ConvertTo-Json -Depth 5 | Set-Content -Path $jsonPath -Encoding utf8
Write-Host "Success! Generated cloud identity profiles at $jsonPath"
