resource "azurerm_resource_group" "this" {
  name     = uuid()
  location = "westeurope"
}

module "network" {
  source              = "./module"
  vnet_name           = "vn-example"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.255.0.0/24"]
  dns_servers         = ["8.8.8.8"]
  subnets = [
    {
      name : "AzureBastionSubnet"
      address_prefixes : ["10.255.0.0/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory"
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-example-endpoints"
      address_prefixes : ["10.255.0.64/26"]
      enforce_private_link_endpoint_network_policies : false
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    }
  ]
  tags = {
    Created : "Terraform",
    Project : "Simple Example Virtual Network"
  }
}
