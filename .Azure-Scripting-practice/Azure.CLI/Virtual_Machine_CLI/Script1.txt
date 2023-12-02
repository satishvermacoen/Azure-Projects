#!/bin/bash

# Variables
resourceGroupName="BackupTest"
vmName="vm01"
location="centralindia"
adminUsername="admin"
adminPassword="@Password12345>"
vmSize="Standard_B1s"
vnetName="TutorialVNet1"
subnetName="TutorialSubnet1"
nsg="TutorialVM1NSG"

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a virtual network
az network vnet create --resource-group $resourceGroupName --name $vnetName --location $location

# Create a subnet
az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName

# Create a virtual machine without a public IP address.
az vm create 
  --resource-group $resourceGroupName \
  --name $vmName \
  --location $location \
  --size $vmSize \
  --image UbuntuLTS \
  --admin-username $adminUsername --admin-password $adminPassword \
  --vnet-name $vnetName --subnet $subnetName --public-ip-address "" \
  --nsg $nsg