# 1. Fetch the active client configuration details automatically
data "azuread_client_config" "infra_client" {}

# 2. Automate the creation of the secure Resource Group container
resource "azurerm_resource_group" "migration_rg" {
  name     = "IAM-Migration-RG"
  location = "UK South"
}

# 3. Deploy a Secure Enterprise Azure Key Vault Blueprint inside the new container
resource "azurerm_key_vault" "migration_vault" {
  name                        = "iam-migration-vault-2026"
  location                    = azurerm_resource_group.migration_rg.location
  resource_group_name         = azurerm_resource_group.migration_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azuread_client_config.infra_client.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  enable_rbac_authorization = true
  sku_name                  = "standard"
}

# 4. Grant Explicit Secret Officer Privileges to the IT Operations Team
resource "azurerm_role_assignment" "it_ops_vault_access" {
  scope                = azurerm_key_vault.migration_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azuread_group.department_groups["IT-Operations"].object_id
}
