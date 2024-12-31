output "resource_group_name" {
  value = azurerm_resource_group.master_controller.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.module5_vm_master.public_ip_address
}

output "public_key" {
  value = tls_private_key.ssh-pkey.public_key_openssh
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.module5_aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.module5_aks.kube_config_raw

  sensitive = true
}

# output "key_data" {
#   value = azurerm_ssh_public_key.ssh_key.public_key
# }