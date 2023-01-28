variable "location" {
  default = "West Europe"
}

variable "network_ip_address" {
  default = ["10.20.0.0/16"]
}

variable "subnet_ip" {
  default = ["10.20.10.0/24"]
}

variable "size" {
  default = "Standard_B1s"
}

variable "jenkins" {
  default = "jenkins.sh"
}

variable "ssh_key" {
  default = "id_rsa.pub"
}

variable "storage_account_type" {
 default = "Standard_LRS"
}