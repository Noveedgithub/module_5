resource "azurerm_linux_virtual_machine" "module5_vm_master" {
  name                  = "module5_vm_master"
  location              = azurerm_resource_group.master_controller.location
  resource_group_name   = azurerm_resource_group.master_controller.name
  network_interface_ids = [azurerm_network_interface.module5_nic_master.id]
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

  # provisioner "local-exec" {
  #   command = "ssh-keyscan -H ${azurerm_linux_virtual_machine.module5_vm_master.public_ip_address} >> ~/.ssh/known_hosts"
  # }

  # provisioner "file" {
  #   source      = "install_ansible.sh"
  #   destination = "/tmp/install_ansible.sh"

  #   connection {
  #     type        = "ssh"
  #     host        = self.public_ip_address
  #     user        = "noveed"
  #     private_key = tls_private_key.ssh-pkey.private_key_pem
  #   }
  # }

  # provisioner "file" {
  #   source      = "install_terraform.sh"
  #   destination = "/tmp/install_terraform.sh"

  #   connection {
  #     type        = "ssh"
  #     host        = self.public_ip_address
  #     user        = "noveed"
  #     private_key = tls_private_key.ssh-pkey.private_key_pem
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/install_ansible.sh",
  #     "chmod +x /tmp/install_terraform.sh",
  #     "/tmp/install_ansible.sh",
  #     "/tmp/install_terraform.sh",
  #     # "ssh-keyscan -H ${self.public_ip_address} >> ~/.ssh/known_hosts",
  #     "sleep 120" # Wait for VM to initialize
  #   ]

  #   connection {
  #     type        = "ssh"
  #     host        = self.public_ip_address
  #     user        = "noveed"
  #     private_key = tls_private_key.ssh-pkey.private_key_pem
  #   }
  # }

  # user_data = base64encode("#!/bin/bash\nsudo apt update -y\nsudo apt install software-properties-common -y\nsudo add-apt-repository --yes --update ppa:ansible/ansible\nsudo apt install ansible -y")
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.module5_vm_master.id
  location           = azurerm_resource_group.master_controller.location
  enabled            = true

  daily_recurrence_time = "1730"
  timezone              = "GMT Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = "noveed.muhammed@hse.gov.uk"
  }
  depends_on = [azurerm_linux_virtual_machine.module5_vm_master, tls_private_key.ssh-pkey]
}