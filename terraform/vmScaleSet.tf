resource "azurerm_linux_virtual_machine_scale_set" "password_app_vmss" {
  name                = "password_app_vmss"
  location            = azurerm_resource_group.password_app_rg.location
  resource_group_name = azurerm_resource_group.password_app_rg.name

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = false
    disable_automatic_rollback  = false
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  upgrade_mode = "Rolling"

  health_probe_id = azurerm_lb_probe.password_app_probe.id

  instances = 2
  sku       = "Standard_B1s"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username       = "passwordAppAdmin"
  computer_name_prefix = "passwordApp"
  custom_data          = filebase64("bash/run-app-image.sh")

  data_disk {
    lun                  = 0
    caching              = "ReadWrite"
    create_option        = "Empty"
    disk_size_gb         = 10
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username="passwordAppAdmin"
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  network_interface {
    name                      = "networkprofile"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.password_app_nsg.id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.password_app_subneet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.password_app_bepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.password_app_lbnatpool.id]
    }
  }
}