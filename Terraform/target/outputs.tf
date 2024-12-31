output "resource_group_name" {
  value = azurerm_resource_group.target_group.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.module5_vm.public_ip_address
}

output "public_key" {
  value = tls_private_key.ssh-pkey.public_key_openssh
}