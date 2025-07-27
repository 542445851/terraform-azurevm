resource "azurerm_resource_group" "test_rg" {
    name = var.resource_group_name
    location = var.resource_group_location
  
}

resource "azurerm_virtual_network" "test_vn" {
    name = "dev-network"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.test_rg.location
    resource_group_name = azurerm_resource_group.test_rg.name
  
}

resource "azurerm_subnet" "test_sbn" {
    name = "dev-subnet"
    resource_group_name = azurerm_resource_group.test_rg.name
    virtual_network_name = azurerm_virtual_network.test_vn.name
    address_prefixes = [ "10.0.2.0/24" ]
  
}

resource "azurerm_network_security_group" "test_nsg" {
    name = "dev-nsg"
    location = azurerm_resource_group.test_rg.location
    resource_group_name = azurerm_resource_group.test_rg.name

    security_rule = {
        name                           ="RDP"
        priority                       = 1000
        direction                      = "Inbound"
        access                         = "Allow"
        protocol                       = "*"
        source_port_range              = "*"
        destination_port_range         ="*"
        source_address_prefix          ="*"
        destination_address_prefix     ="*"
    }

}

resource "azurerm_network_interface" "test_nic" {
    name = "dev-nic"
    location = azurerm_resource_group.test_rg.location
    resource_group_name = azurerm_resource_group.test_rg.name
    
    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.test_sbn.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface_security_group_association" "test" {
    network_interface_id = azurerm_network_interface.test_nic.id
    network_security_group_id = azurerm_network_security_group.test_nsg.id
  
}

resource "azurerm_windows_virtual_machine" "test_vm" {
    name = "dev-machine"
    resource_group_name = azurerm_resource_group.test_rg.name
    location = azurerm_resource_group.test_rg.location
    size = "Standard_F2"
    admin_username = "adminuser"
    admin_password = "Password1234!"
    network_interface_ids = [
        azurerm_network_interface.test_nic.id,
        ]
        os_disk {
          caching = "Readwrite"
          storage_account_type = "standard_LRS"
        }
        source_image_reference {
          publisher = "MicrosoftWindowsServer"
          offer = "WindowsServer"
          sku = "2016-Datacenter"
          version = "latest"

        }
  
}

