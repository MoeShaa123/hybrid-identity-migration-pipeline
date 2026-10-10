# 1. Fetch the active client configuration details automatically
data "azuread_client_config" "infra_client" {}

# 2. Deploy a Secure Enterprise Azure Key Vault Blueprint using the correct azurerm prefix
resource "azurerm_key_vault" "migration_vault" {
  name                        = "iam-migration-vault-2026"
  location                    = "UK South"
  resource_group_name         = "IAM-Migration-RG"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azuread_client_config.infra_client.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  # Use standard, modern Azure Role-Based Access Control
  enable_rbac_authorization = true

  sku_name = "standard"
}

# 3. Grant Explicit Secret Officer Privileges to the IT Operations Team
resource "azurerm_role_assignment" "it_ops_vault_access" {
  scope                = azurerm_key_vault.migration_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azuread_group.department_groups["IT-Operations"].object_id
}
