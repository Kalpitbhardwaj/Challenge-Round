#APP VM
resource "random_password" "windows_password" {
  length           = 12
  special          = true
  override_special = "_%@+"
}

resource "azurerm_network_interface" "vm1nic" {
  name                = "vm1nic"
  location            = azurerm_resource_group.apprg.location
  resource_group_name = azurerm_resource_group.apprg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vm2nic" {
  name                = "vm2nic"
  location            = azurerm_resource_group.apprg.location
  resource_group_name = azurerm_resource_group.apprg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "ProjectName-vm1"
  resource_group_name = azurerm_resource_group.apprg.name
  location            = azurerm_resource_group.apprg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = random_password.windows_password.result
  network_interface_ids = [
    azurerm_network_interface.vm1nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "ProjectName-vm2"
  resource_group_name = azurerm_resource_group.apprg.name
  location            = azurerm_resource_group.apprg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = random_password.windows_password.result
  network_interface_ids = [
    azurerm_network_interface.vm2nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

#VM Extension
resource "azurerm_virtual_machine_extension" "vmextension1" {
  name                 = "vmextension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.appvmextnstore1.name}.blob.core.windows.net/${azurerm_storage_container.appvmcont.name}/${azurerm_storage_blob.iisconfig.name}"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file iis.ps1"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "vmextension2" {
  name                 = "vmextension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.appvmextnstore1.name}.blob.core.windows.net/${azurerm_storage_container.appvmcont.name}/${azurerm_storage_blob.iisconfig.name}"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file iis.ps1"
    }
SETTINGS
}

#Web Virtual machine scale set
resource "azurerm_windows_virtual_machine_scale_set" "vmss1" {
  name                = "vmss1"
  resource_group_name = azurerm_resource_group.webrg.name
  location            = azurerm_resource_group.webrg.location
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "adminuser"
  admin_password      = "Password@1"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss1nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet2.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.weblbbep.id]
    }
  }
  extension {
    name                       = "CustomScript"
    publisher                  = "Microsoft.Compute"
    type                       = "CustomScriptExtension"
    type_handler_version       = "1.10"
    auto_upgrade_minor_version = true

    settings = jsonencode({ "fileUris" : ["https://${azurerm_storage_account.appvmextnstore1.name}.blob.core.windows.net/${azurerm_storage_container.appvmcont.name}/${azurerm_storage_blob.iisconfig.name}"],
    "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -file iis.ps1" })
  }
}

