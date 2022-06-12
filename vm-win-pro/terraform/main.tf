## <https://www.terraform.io/docs/providers/azurerm/index.html>
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


locals {
  timestamp = "20220609"
}

## <https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
resource "azurerm_windows_virtual_machine" "example" {
  name                     = var.machineName
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  size                     = "Standard_B4ms"
  admin_username           = var.username
  admin_password           = data.azurerm_key_vault_secret.vmPassword.value
  enable_automatic_updates = true

  availability_set_id = azurerm_availability_set.asetSprint.id

  network_interface_ids = [
    azurerm_network_interface.nicSprinter.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "1000"
  }

  # provisioner "file" {
  #   source      = "./files/config.ps1"
  #   destination = "c:/terraform/config.ps1"
  #   connection {
  #     host     = azurerm_public_ip.public_ip.fqdn
  #     type     = "winrm"
  #     port     = 5985
  #     https    = false
  #     timeout  = "2m"
  #     user     = var.username
  #     password = var.password
  #   }
  # }

  #provisioner "remote-exec" {
  #  connection {
  #    host     = azurerm_public_ip.public_ip.fqdn
  #    type     = "winrm"
  #    user     = var.username
  #    password = var.password
  #  }
  #
  #  inline = [
  #    "PowerShell.exe -ExecutionPolicy Bypass mkdir test",
  #  ]
  #}

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

  winrm_listener {
    protocol = "Http"
    #certificate_url = "https://kvgpsecrets.vault.azure.net/keys/winrmcert/906583eecd254e2b9f2a91d54437f7f4"
  }
}
