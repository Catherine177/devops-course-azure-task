# Create subnet
resource "azurerm_subnet" "subnet_2_private" {
  name                 = "subnet-2-private"
  resource_group_name  = azurerm_resource_group.final_task_rg.name
  virtual_network_name = azurerm_virtual_network.final_task_vnet.name
  address_prefixes     = ["10.1.2.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

# Create public IP for NAT gateway
resource "azurerm_public_ip" "final_task_nat_gateway_pip" {
  name                = "final-task-nat-gateway-pip"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create public IP prefix for NAT gateway
resource "azurerm_public_ip_prefix" "final_task_nat_gateway_pip_prefix" {
  name                = "final-task-nat-gateway-pip-prefix"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name
  prefix_length       = 29
}

# Create NAT gateway
resource "azurerm_nat_gateway" "final_task_nat_gateway" {
  name                    = "final-task-nat-gateway"
  location                = azurerm_resource_group.final_task_rg.location
  resource_group_name     = azurerm_resource_group.final_task_rg.name
  public_ip_address_ids   = [azurerm_public_ip.final_task_nat_gateway_pip.id]
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.final_task_nat_gateway_pip_prefix.id]
  sku_name                = "Standard"
}

# Create NAT gateway association with subnet-2
resource "azurerm_subnet_nat_gateway_association" "final_task_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet_2_private.id
  nat_gateway_id = azurerm_nat_gateway.final_task_nat_gateway.id
}

# Create network interface
resource "azurerm_network_interface" "final_task_nic_vm_2" {
  name                = "final-task-nic-vm-2"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.final_task_rg.name

  ip_configuration {
    name                          = "ip-config-2"
    subnet_id                     = azurerm_subnet.subnet_2_private.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "final_task_vm_2" {
  name                  = "final-task-vm-2"
  location              = azurerm_resource_group.final_task_rg.location
  resource_group_name   = azurerm_resource_group.final_task_rg.name
  network_interface_ids = [azurerm_network_interface.final_task_nic_vm_2.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "os-disk-2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm2"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.final_task_ssh.public_key_openssh
  }
}