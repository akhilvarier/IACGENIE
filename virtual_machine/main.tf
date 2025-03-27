To create a new Terraform module named `virtual_machine`, we'll adhere to best practices and ensure consistency in variable naming and structure. Here is a basic outline and example of how the module might look:

### Directory Structure

```
virtual_machine/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
```

### main.tf
This file contains the primary resource definitions.

```hcl
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_type
  }

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}
```

### variables.tf
This file defines the input variables for the module.

```hcl
variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "location" {
  description = "The location where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS1_v2"
}

variable "os_disk_type" {
  description = "The type of OS disk to use."
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "The publisher of the image to use."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the image to use."
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "The SKU of the image to use."
  type        = string
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "The version of the image to use."
  type        = string
  default     = "latest"
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
```

### outputs.tf
This file defines the outputs from the module.

```hcl
output "vm_id" {
  description = "The ID of the virtual machine."
  value       = azurerm_virtual_machine.vm.id
}

output "vm_name" {
  description = "The name of the virtual machine."
  value       = azurerm_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine."
  value       = azurerm_public_ip.vm_public_ip.ip_address
}
```

