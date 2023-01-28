provider "azurerm" {
    features {}
    subscription_id = "Your_subscription_id"
    tenant_id       = "Your_tenant_id"
    client_id       = "Your_client_id"
    client_secret   = "Your_client_secret"
}

 resource "azurerm_resource_group" "jenkins_azure" {
  name     = "jenkins-resources"
  location = var.location
}

resource "azurerm_virtual_network" "jenkins_network" {
  name                = "jenkins-network"
  address_space       = var.network_ip_address
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins_azure.name
}

resource "azurerm_subnet" "jenkins_subnet" {
  name                 = "jenkins-subnet"
  resource_group_name  = azurerm_resource_group.jenkins_azure.name
  virtual_network_name = azurerm_virtual_network.jenkins_network.name
  address_prefixes     = var.subnet_ip
}

resource "azurerm_public_ip" "jenkins_public_ip" {
  name                = "jenkins-public-ip"
  location            = azurerm_resource_group.jenkins_azure.location
  resource_group_name = azurerm_resource_group.jenkins_azure.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jenkins_network" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.jenkins_azure.location
  resource_group_name = azurerm_resource_group.jenkins_azure.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jenkins_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                  = "jenkins-vm"
  resource_group_name   = azurerm_resource_group.jenkins_azure.name
  location              = azurerm_resource_group.jenkins_azure.location
  size                  = var.size
  admin_username        = "vstelmakh"
  custom_data           = filebase64(var.jenkins)
  network_interface_ids = [
    azurerm_network_interface.jenkins_network.id,
  ]

  admin_ssh_key {
    username   = "vstelmakh"
    public_key = file(var.ssh_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2" 
    version   = "latest"
  }
}