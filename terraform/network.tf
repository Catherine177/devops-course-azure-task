# Create resource group
resource "azurerm_resource_group" "final_task_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "final_task_vnet" {
  name                = "final-task-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name
}

# Create network watcher
resource "azurerm_network_watcher" "final_task_network_watcher" {
  name                = "final-task-network-watcher"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "final_task_nsg" {
  name                = "final-task-nsg"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                        = "AccessToInternet"
    priority                    = 1002
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "final_task_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
