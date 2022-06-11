#
#
#

data "azurerm_key_vault" "kvGPSecrets" {
    name = "kvGPSecrets"
    resource_group_name = "jkw-resources"
}

data "azurerm_key_vault_secret" "vmPassword" {
    name = "SprinterPassword"
    key_vault_id = data.azurerm_key_vault.kvGPSecrets.id
}