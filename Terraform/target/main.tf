resource "azurerm_resource_group" "target_group" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "module5_vnet" {
  name                = "module5_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.target_group.location
  resource_group_name = azurerm_resource_group.target_group.name
}

# Create subnet
resource "azurerm_subnet" "module5-subnet" {
  name                 = "module5-subnet"
  resource_group_name  = azurerm_resource_group.target_group.name
  virtual_network_name = azurerm_virtual_network.module5_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "module5_public_ip" {
  name                = "module5_public_ip"
  location            = azurerm_resource_group.target_group.location
  resource_group_name = azurerm_resource_group.target_group.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "module5_nic" {
  name                = "module5_nic"
  location            = azurerm_resource_group.target_group.location
  resource_group_name = azurerm_resource_group.target_group.name

  ip_configuration {
    name                          = "module5_nic_configuration"
    subnet_id                     = azurerm_subnet.module5-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.module5_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.module5_nic.id
  network_security_group_id = azurerm_network_security_group.module5_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.target_group.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.target_group.location
  resource_group_name      = azurerm_resource_group.target_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}