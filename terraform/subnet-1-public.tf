# Create subnet
resource "azurerm_subnet" "subnet_1_public" {
  name                 = "subnet-1-public"
  resource_group_name  = azurerm_resource_group.final_task_rg.name
  virtual_network_name = azurerm_virtual_network.final_task_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "final_task_pip" {
  name                = "final-task-pip"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Create network interface
resource "azurerm_network_interface" "final_task_nic_vm_1" {
  name                = "final-task-nic-vm-1"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.final_task_rg.name

  ip_configuration {
    name                          = "ip-config-1"
    subnet_id                     = azurerm_subnet.subnet_1_public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.final_task_pip.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "final_task_vm_1" {
  name                  = "final-task-vm-1"
  location              = azurerm_resource_group.final_task_rg.location
  resource_group_name   = azurerm_resource_group.final_task_rg.name
  network_interface_ids = [azurerm_network_interface.final_task_nic_vm_1.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "os-disk-1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm1"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.final_task_ssh.public_key_openssh
  }
}