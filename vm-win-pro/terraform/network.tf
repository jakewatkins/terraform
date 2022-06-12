
## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
resource "azurerm_virtual_network" "vnet" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vmPublicIp" {
  name                = "vm_public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  domain_name_label   = "vm-jkw-ws-sprinter"
  allocation_method   = "Dynamic"
}

## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
resource "azurerm_network_interface" "nicSprinter" {
  name                = "sprinter-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmPublicIp.id
  }
}

resource "azurerm_network_security_group" "nsgSprinter" {
    name = "sprinter-network-security-group"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsgrSprinterInbound" {
    name = "home-workstation"
    priority = 100
    direction = "Inbound"
    access = "Allow"  
    protocol = "Tcp"
    source_port_range = "*"
    source_address_prefix = var.workstation_ip
    destination_address_prefix = "*"
    destination_port_range = "*"
    network_security_group_name = azurerm_network_security_group.nsgSprinter.name
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsgrSprinterOutbound" {
    name = "outbound"
    priority = 100
    direction = "Outbound"
    access = "Allow"  
    protocol = "Tcp"
    source_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    destination_port_range = "*"
    network_security_group_name = azurerm_network_security_group.nsgSprinter.name
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "snet-nsg-association-sprint" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsgSprinter.id
}