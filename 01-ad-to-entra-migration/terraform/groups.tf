# 1. Dynamically read your generated local JSON dataset
locals {
  raw_data = jsondecode(file("${path.module}/../data/identities.json"))
  user_map = { for u in local.raw_data : u.UserPrincipalName => u }
}

# 2. Query your live Azure Cloud tenant to fetch your exact, verified onmicrosoft.com domain
data "azuread_domains" "default" {
  only_initial = true
}

# 3. Automate User Provisioning across the Entra ID Cloud Directory
resource "azuread_user" "migrated_users" {
  for_each = local.user_map
  
  # Programmatically strip the old domain and inject your real, verified Azure tenant domain name
  user_principal_name = "${split("@", each.value.UserPrincipalName)[0]}@${data.azuread_domains.default.domains[0].domain_name}"
  
  display_name        = "${each.value.FirstName} ${each.value.LastName}"
  mail_nickname       = "${lower(each.value.FirstName)}.${lower(each.value.LastName)}"
  department          = each.value.Department
  job_title           = each.value.JobTitle
  given_name          = each.value.FirstName  # Maps straight to Azure's First Name field
  surname             = each.value.LastName   # Maps straight to Azure's Last Name field
  
  password            = "SecureNHSMigration2026!"
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
