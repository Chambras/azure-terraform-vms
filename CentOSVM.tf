resource "azurerm_public_ip" "centosPublicIP" {
  name                = "${var.suffix}${var.centosVMName}"
  location            = azurerm_resource_group.mainRG.location
  resource_group_name = azurerm_resource_group.mainRG.name
  allocation_method   = var.publicIPAllocation

  tags = var.tags
}

resource "azurerm_network_interface" "centosNI" {
  name                = "${var.suffix}${var.centosVMName}"
  location            = azurerm_resource_group.mainRG.location
  resource_group_name = azurerm_resource_group.mainRG.name

  ip_configuration {
    name                          = "centosconfiguration"
    subnet_id                     = azurerm_subnet.frontend2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.centosPublicIP.id
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "centosSG" {
  network_interface_id      = azurerm_network_interface.centosNI.id
  network_security_group_id = azurerm_network_security_group.sshNSG.id
}

resource "azurerm_linux_virtual_machine" "centosVM" {
  name                = "${var.suffix}${var.centosVMName}"
  resource_group_name = azurerm_resource_group.mainRG.name
  location            = azurerm_resource_group.mainRG.location
  size                = var.vmSize
  admin_username      = var.vmUserName
  #  encryption_at_host_enabled = true
  network_interface_ids = [azurerm_network_interface.centosNI.id, ]

  admin_ssh_key {
    username   = var.vmUserName
    public_key = file(var.sshKeyPath)
  }

  os_disk {
    name                 = "${var.suffix}${var.centosVMName}OSDisk"
    caching              = "ReadWrite"
    storage_account_type = var.osDisk
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = var.centossku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mainSA.primary_blob_endpoint
  }

  # from file
  custom_data = filebase64("cloud-init.yaml")

  # from variable
  #custom_data = base64encode(local.custom_data)

  # in-line
  /* custom_data = base64encode(<<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  packages:
    - httpd
    - java-1.8.0-openjdk-devel
    - git 
  write_files:
    - content: <!doctype html><html><body><h1>Hello CentOS 2019 from Azure!</h1></body></html>
      path: /var/www/html/index.html
  runcmd:
    - [ systemctl, enable, httpd.service ]
    - [ systemctl, start, httpd.service ]

  CUSTOM_DATA
  )
*/
  tags = var.tags
}
