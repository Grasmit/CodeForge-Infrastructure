# Create a resource group
resource "azurerm_resource_group" "password_app_rg" {

    name = "password_app_rg"
    location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "password_app_network" {

    name="password_app_network"
    resource_group_name = azurerm_resource_group.password_app_rg.name
    location = azurerm_resource_group.password_app_rg.location
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "password_app_subneet" {
    name = "password_app_subnet"
    resource_group_name = azurerm_resource_group.password_app_rg.name
    virtual_network_name = azurerm_virtual_network.password_app_network.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "password_app_public_ip" {
    name = "password_app_public_ip"
    location = azurerm_resource_group.password_app_rg.location
    resource_group_name = azurerm_resource_group.password_app_rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "password_app_nsg" {
    name = "password_app_nsg"
    location = azurerm_resource_group.password_app_rg.location
    resource_group_name = azurerm_resource_group.password_app_rg.name

    security_rule {
        name = "RDP"
        priority = 1000
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name = "web"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "password_app_nic" {
    name = "password_app_nic"
    location = azurerm_resource_group.password_app_rg.location
    resource_group_name = azurerm_resource_group.password_app_rg.name

    ip_configuration {
        name = "password_app_nic_config"
        subnet_id = azurerm_subnet.password_app_subneet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.password_app_public_ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "password_app_nic_sga" {
    network_interface_id = azurerm_network_interface.password_app_nic.id
    network_security_group_id = azurerm_network_security_group.password_app_nsg.id
}

resource "azurerm_linux_virtual_machine" "password_app_linux_vm" {
    name = "password-app-linux-vm"
    resource_group_name = azurerm_resource_group.password_app_rg.name
    location = azurerm_resource_group.password_app_rg.location
    size = "Standard_D2_v2"
    admin_username = "passwordAppAdmin"
    admin_password = "Password1234!"

    network_interface_ids = [
        azurerm_network_interface.password_app_nic.id,
    ]

    os_disk {
        name = "ubuntu-linux-vm-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }  

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS" 
        version   = "latest"
    }

    admin_ssh_key {
        username="passwordAppAdmin"
        public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }

resource "azurerm_virtual_machine_extension" "password-app-containerd" {

    name = "password-app-containerd"
    virtual_machine_id = azurerm_linux_virtual_machine.password_app_linux_vm.id
    publisher = "Microsoft.Azure.Extensions"
    type = "CustomScript"
    type_handler_version = "2.0"

    settings = jsonencode({
        fileUris = ["https://raw.githubusercontent.com/Grasmit/infrastructure-as-a-code/master/bash/run-app-image.sh"]
        commandToExecute = "bash run-app-image.sh"
    })
}