To create a new Terraform module named `azurerm_virtual_network`, we'll follow best practices and ensure consistency in variable naming and structure. I'll outline the necessary files and their contents for this module. The module will include a main Terraform configuration file, a variables file, and an outputs file.

### Directory Structure
```
azurerm_virtual_network/
├── main.tf
├── variables.tf
└── outputs.tf
```

### main.tf
This file will define the `azurerm_virtual_network` resource using the Azure provider. 

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
    }
  }
}
```

### variables.tf
This file will define the input variables for the module. 

```hcl
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}

variable "location" {
  description = "The location/region where the virtual network is created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

variable "subnets" {
  description = "A list of subnets to associate with the virtual network."
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
```

### outputs.tf
This file will define the outputs for the module.

```hcl
output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "The address space of the virtual network."
  value       = azurerm_virtual_network.this.address_space
}
```

### Usage Example
This is how you might use this module in a parent Terraform configuration:

```hcl
module "vnet" {
  source              = "./azurerm_virtual_network"
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "my-resource-group"
  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "subnet2"
      address_prefix = "10.0.2.0/24"
    },
  ]
  tags = {
    Environment = "Dev"
    Project     = "TerraformExample"
  }
}
```

This module provides a clean and reusable way to create Azure virtual networks with subnets, following Terraform's best practices for module design.