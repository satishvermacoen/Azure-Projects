#!/bin/bash

# Define variables
rgname="testrg01"
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
