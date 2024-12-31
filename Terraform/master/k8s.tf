resource "azurerm_kubernetes_cluster" "module5_aks" {
  name                = "module5_aks"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "module5-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "kubernetes_namespace" "Jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      environment = "development"
    }
  }
}