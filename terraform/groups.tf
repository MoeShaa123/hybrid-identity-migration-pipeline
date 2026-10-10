# 1. Dynamically read your generated local JSON dataset
locals {
  raw_data = jsondecode(file("${path.module}/../data/identities.json"))
  user_map = { for u in local.raw_data : u.UserPrincipalName => u }
}

# 2. Programmatically generate unique, compliant random passwords for each user
resource "random_password" "user_passwords" {
  for_each         = local.user_map
  length           = 12 # Safely over your 10-character minimum
  special          = false
  upper            = true
  numeric          = true
  lower            = true
  min_upper        = 1  # Guarantees at least 1 capital letter
  min_numeric      = 1  # Guarantees at least 1 number
}

# 3. Automate User Provisioning across the Entra ID Cloud Directory
resource "azuread_user" "migrated_users" {
  for_each            = local.user_map
  user_principal_name = each.value.UserPrincipalName
  display_name        = "${each.value.FirstName} ${each.value.LastName}"
  mail_nickname       = "${lower(each.value.FirstName)}.${lower(each.value.LastName)}"
  department          = each.value.Department
  job_title           = each.value.JobTitle
  
  # Passes the uniquely generated secure password string
  password            = random_password.user_passwords[each.key].result
  
  # Forces the user to change it instantly upon their first sign-in screen
  force_password_change = true
}

# 4. Provision Isolated Corporate Department Security Groups
resource "azuread_group" "department_groups" {
  for_each         = toset([for u in local.raw_data : u.Department])
  display_name     = "${each.key}-Security-Group"
  security_enabled = true
  description      = "Automated governance group for the ${each.key} enterprise business unit."
}

# 5. Programmatically Assign Users to their Respective Department Groups
resource "azuread_group_member" "assignments" {
  for_each = {
    for u in local.raw_data : u.UserPrincipalName => u.Department
  }

  group_object_id  = azuread_group.department_groups[each.value].object_id
  member_object_id = azuread_user.migrated_users[each.key].object_id
}
