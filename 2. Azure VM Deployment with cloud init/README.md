EVERYTHING IS PRE-CONFIGURED-GIT REPO.
# 2. Azure VM Deployment with cloud init.
In this Project, a Deployment of Azure and configure as wedserver and ready to with live website(My Resume) hosted on Azure VM. All this deployment with automate with one script and cloud init.txt.
<After pointing it to the domain name with the use of Azure DNS.>
## Azure Resource Created

1. Azure Virtual Network 
2. Azure Vitual Machine
3. Public-IP
4. NSG

![Overview](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/draw.png)

## Process

![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(121).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(122).png)

### Cloud init.txt

1. Create and save the the cloud init.txt for post package install and deployment configuration.

```bash
  #cloud-config
package_upgrade: true
packages:
  - git
  - nodejs
  - npm
  - nginx
runcmd:
  - cd "/var/www"
  - rm -Rf html
  - cd "/var/www"
  - git clone "https://github.com/satishvermacoen/html/"
  - systemctl nginx restart

```
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(124).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(125).png)

2. Save this Cloud-init.txt and upload in Azure Portal Cloud Shell(CLI)

![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(126).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(127).png)

3. Code for VM Deployment and supported Resource.

```bash
#!/bin/bash

# Define variables
rgname="rg01"
location="eastus"
vmName="vm01"
adminUsername="satish"
adminPassword="@Password12345"
vnetName="vent01"
subnetName="Subnet-0"
publicIpAddressName="publicip-01"
nsgName="nsg01"
vmSize="Standard_B1s"
image="Ubuntu2204"
customDataFile="cloud-init.txt"

# Create a resource group
az group create --name $rgname --location $location

echo "ResourceGroup deployment complete."
# Create a virtual network
az network vnet create --resource-group $rgname --name $vnetName --location $location --address-prefixes 10.2.0.0/16

echo "Virtual-Network deployment complete."
# Create a subnet
az network vnet subnet create --resource-group $rgname --vnet-name $vnetName --name $subnetName --address-prefixes 10.2.1.0/24

echo "Subnet deployment complete."
# Create a public IP address
az network public-ip create --resource-group $rgname --name $publicIpAddressName --sku Basic --allocation-method Dynamic

echo "Public-IP deployment complete."
# Create a network security group and open ports 22 (SSH) and 80 (HTTP)
az network nsg create --resource-group $rgname --name $nsgName
az network nsg rule create --resource-group $rgname --nsg-name $nsgName --name allow-ssh --priority 100 --protocol Tcp --destination-port-range 22 --access Allow
az network nsg rule create --resource-group $rgname --nsg-name $nsgName --name allow-http --priority 110 --protocol Tcp --destination-port-range 80 --access Allow

echo "NSG and Rule deployed and Configured complete."
# Create the virtual machine with a custom data script
az vm create --resource-group $rgname --name $vmName --location $location --size $vmSize --image $image --admin-username $adminUsername --admin-password $adminPassword --public-ip-address $publicIpAddressName --nsg $nsgName --vnet-name $vnetName --subnet $subnetName --custom-data $customDataFile

# Output the public IP address of the VM
az vm show --resource-group $rgname --name $vmName --show-details --query [publicIps] --output tsv

echo "VM deployment complete."

```
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(130).png)
#### Output
``` Output

{
  "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02",
  "location": "eastus",
  "managedBy": null,
  "name": "testrg02",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
ResourceGroup deployment complete.
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.2.0.0/16"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"b25677ba-25bb-4851-a22f-8c35e256146f\"",
    "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/virtualNetworks/vent01",     
    "location": "eastus",
    "name": "vent01",
    "provisioningState": "Succeeded",
    "resourceGroup": "testrg02",
    "resourceGuid": "8ebc1da7-74a8-4373-8b76-bb75353aec83",
    "subnets": [],
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
Virtual-Network deployment complete.
{
  "addressPrefix": "10.2.1.0/24",
  "delegations": [],
  "etag": "W/\"ab6a54f3-a528-477b-9e7a-67d8488ef8d5\"",
  "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/virtualNetworks/vent01/subnets/Subnet-0",
  "name": "Subnet-0",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "testrg02",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
Subnet deployment complete.
It's recommended to create with `--sku standard`. Please be aware that the default Public IP SKU will be changed from Basic to Standard in the next release. Also note that Basic option will be removed in the future.
{
  "publicIp": {
    "etag": "W/\"b84b61ca-e424-4214-9efd-e8c4a9edc357\"",
    "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/publicIPAddresses/publicip-01",
    "idleTimeoutInMinutes": 4,
    "ipTags": [],
    "location": "eastus",
    "name": "publicip-01",
    "provisioningState": "Succeeded",
    "publicIPAddressVersion": "IPv4",
    "publicIPAllocationMethod": "Dynamic",
    "resourceGroup": "testrg02",
    "resourceGuid": "230ea627-a64c-473a-b03a-cfa94ceaa10b",
    "sku": {
      "name": "Basic",
      "tier": "Regional"
    },
    "type": "Microsoft.Network/publicIPAddresses"
  }
}
Public-IP deployment complete.
{
  "NewNSG": {
    "defaultSecurityRules": [
      {
        "access": "Allow",
        "description": "Allow inbound traffic from all VMs in VNET",
        "destinationAddressPrefix": "VirtualNetwork",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Inbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/AllowVnetInBound",
        "name": "AllowVnetInBound",
        "priority": 65000,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "VirtualNetwork",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      },
      {
        "access": "Allow",
        "description": "Allow inbound traffic from azure load balancer",
        "destinationAddressPrefix": "*",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Inbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/AllowAzureLoadBalancerInBound",
        "name": "AllowAzureLoadBalancerInBound",
        "priority": 65001,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "AzureLoadBalancer",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      },
      {
        "access": "Deny",
        "description": "Deny all inbound traffic",
        "destinationAddressPrefix": "*",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Inbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/DenyAllInBound",
        "name": "DenyAllInBound",
        "priority": 65500,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "*",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      },
      {
        "access": "Allow",
        "description": "Allow outbound traffic from all VMs to all VMs in VNET",
        "destinationAddressPrefix": "VirtualNetwork",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Outbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/AllowVnetOutBound",
        "name": "AllowVnetOutBound",
        "priority": 65000,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "VirtualNetwork",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      },
      {
        "access": "Allow",
        "description": "Allow outbound traffic from all VMs to Internet",
        "destinationAddressPrefix": "Internet",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Outbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/AllowInternetOutBound",
        "name": "AllowInternetOutBound",
        "priority": 65001,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "*",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      },
      {
        "access": "Deny",
        "description": "Deny all outbound traffic",
        "destinationAddressPrefix": "*",
        "destinationAddressPrefixes": [],
        "destinationPortRange": "*",
        "destinationPortRanges": [],
        "direction": "Outbound",
        "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
        "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/defaultSecurityRules/DenyAllOutBound",
        "name": "DenyAllOutBound",
        "priority": 65500,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "resourceGroup": "testrg02",
        "sourceAddressPrefix": "*",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "type": "Microsoft.Network/networkSecurityGroups/defaultSecurityRules"
      }
    ],
    "etag": "W/\"e15801a6-5374-402f-81f4-3694132f8444\"",
    "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01",    "location": "eastus",
    "name": "nsg01",
    "provisioningState": "Succeeded",
    "resourceGroup": "testrg02",
    "resourceGuid": "1d27321f-de4f-4574-b900-bfd37ee77cce",
    "securityRules": [],
    "type": "Microsoft.Network/networkSecurityGroups"
  }
}
{
  "access": "Allow",
  "destinationAddressPrefix": "*",
  "destinationAddressPrefixes": [],
  "destinationPortRange": "22",
  "destinationPortRanges": [],
  "direction": "Inbound",
  "etag": "W/\"e570d568-f01c-4156-817a-12a06f82265c\"",
  "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/securityRules/allow-ssh",
  "name": "allow-ssh",
  "priority": 100,
  "protocol": "Tcp",
  "provisioningState": "Succeeded",
  "resourceGroup": "testrg02",
  "sourceAddressPrefix": "*",
  "sourceAddressPrefixes": [],
  "sourcePortRange": "*",
  "sourcePortRanges": [],
  "type": "Microsoft.Network/networkSecurityGroups/securityRules"
}
{
  "access": "Allow",
  "destinationAddressPrefix": "*",
  "destinationAddressPrefixes": [],
  "destinationPortRange": "80",
  "destinationPortRanges": [],
  "direction": "Inbound",
  "etag": "W/\"df20c7aa-b174-4967-8713-bf20d4a5eeb8\"",
  "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Network/networkSecurityGroups/nsg01/securityRules/allow-http",
  "name": "allow-http",
  "priority": 110,
  "protocol": "Tcp",
  "provisioningState": "Succeeded",
  "resourceGroup": "testrg02",
  "sourceAddressPrefix": "*",
  "sourceAddressPrefixes": [],
  "sourcePortRange": "*",
  "sourcePortRanges": [],
  "type": "Microsoft.Network/networkSecurityGroups/securityRules"
}
NSG and Rule deployed and Configured complete.
Ignite (November) 2023 onwards "az vm/vmss create" command will deploy Gen2-Trusted Launch VM by default. To know more about the default change 
and Trusted Launch, please visit https://aka.ms/TLaD
{
  "fqdns": "",
  "id": "/subscriptions/08e6467a-9038-461a-ac93-2860b4348ac7/resourceGroups/testrg02/providers/Microsoft.Compute/virtualMachines/vm01",
  "location": "eastus",
  "macAddress": "00-22-48-1E-8C-B4",
  "powerState": "VM running",
  "privateIpAddress": "10.2.1.4",
  "publicIpAddress": "20.231.23.35",
  "resourceGroup": "testrg02",
  "zones": ""
}
20.231.23.35
VM deployment complete.

```
VM Deployment Complete.
- You make change in the script and upload and resue as you required.

4. For Test
```bash
curl #public-ip-address
```
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(131).png)![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(132).png)

## Done for this.
-----------------------------------
Some rough work and test deployment when i creating this script and Project.
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(114).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(115).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(118).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(119).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/Screenshot%20(120).png)