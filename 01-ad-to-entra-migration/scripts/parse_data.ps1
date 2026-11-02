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
    
    # Establish a uniform placeholder cloud user login suffix (Terraform dynamically updates this live)
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

# Convert the identities array into a structured JSON string and save using .NET to strip BOM markers
[System.IO.File]::WriteAllText((Resolve-Path $jsonPath), ($cloudIdentities | ConvertTo-Json -Depth 5))
Write-Host "Success! Generated cloud identity profiles at $jsonPath"
