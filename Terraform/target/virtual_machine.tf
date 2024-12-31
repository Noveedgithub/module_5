# Create virtual machine
resource "azurerm_linux_virtual_machine" "module5_vm" {
  name                  = "module5_vm"
  location              = azurerm_resource_group.target_group.location
  resource_group_name   = azurerm_resource_group.target_group.name
  network_interface_ids = [azurerm_network_interface.module5_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.ssh-pkey.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}