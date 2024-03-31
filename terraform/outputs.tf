output "resource_group_name" {

    value = azurerm_resource_group.password_app_rg.name
}

/*
output "public_ip_address" {
    value = azurerm_linux_virtual_machine.password_app_linux_vm.public_ip_address
} */