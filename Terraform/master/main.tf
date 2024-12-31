# Resource Group
resource "azurerm_resource_group" "master_controller" {
  location = var.resource_group_location
  name     = var.resource_group_name_master
}

resource "azurerm_resource_group" "k8s" {
  location = var.resource_group_location
  name     = var.resource_group_name_k8s
}

# Virtual network
resource "azurerm_virtual_network" "module5_vnet_master" {
  name                = "module5_vnet_master"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.master_controller.location
  resource_group_name = azurerm_resource_group.master_controller.name
}

# Subnet
resource "azurerm_subnet" "module5-subnet_master" {
  name                 = "module5-subnet_master"
  resource_group_name  = azurerm_resource_group.master_controller.name
  virtual_network_name = azurerm_virtual_network.module5_vnet_master.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "module5_public_ip_master" {
  name                = "module5_public_ip_master"
  location            = azurerm_resource_group.master_controller.location
  resource_group_name = azurerm_resource_group.master_controller.name
  allocation_method   = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "module5_nic_master" {
  name                = "module5_nic_master"
  location            = azurerm_resource_group.master_controller.location
  resource_group_name = azurerm_resource_group.master_controller.name

  ip_configuration {
    name                          = "module5_nic_master_configuration"
    subnet_id                     = azurerm_subnet.module5-subnet_master.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.module5_public_ip_master.id
  }
}

# Connect NSG to the network interface
resource "azurerm_network_interface_security_group_association" "NSG2NI_master" {
  network_interface_id      = azurerm_network_interface.module5_nic_master.id
  network_security_group_id = azurerm_network_security_group.module5_nsg_master.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.master_controller.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.master_controller.location
  resource_group_name      = azurerm_resource_group.master_controller.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}