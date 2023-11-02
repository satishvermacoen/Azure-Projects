#!/bin/bash

# Variables
resourceGroupName="gitclonetestproject"
vmName="vm01"
location="eastus"
adminUsername="adminmaster"
adminPassword="@Password12345"
vmSize="Standard_B1s"
vnetName="VNet1"
subnetName="Subnet1"
nsg="VM1NSG"
ippublic="ip921public"

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a virtual network
az network vnet create --resource-group $resourceGroupName --name $vnetName --location $location

# Create a subnet
az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName

# Create a virtual machine without a public IP address.
az vm create   --resource-group $resourceGroupName   --name $vmName   --image Ubuntu2204   --size $vmSize   --vnet-name $vnetName   --subnet $subnetName   --admin-username $adminUsername   --admin-password $adminPassword   --public-ip-address "$ippublic"   --nsg $nsg   --custom-data cloud-init.txt   --output json   --verbose

# To open port -80 for http
az vm open-port --port 80 --resource-group $resourceGroupName --name $vmName