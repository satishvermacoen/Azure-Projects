#!/bin/bash

# Variables
resourceGroupName="BackupTest"
vmName="vm01"
location="centralindia"
adminUsername="satish"
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

# Function to create a virtual machine
create_vm() {
  local vmName=$1

  az vm create --resource-group $resourceGroupName --name $vmName --location $location --size $vmSize \
    --image UbuntuLTS --admin-username $adminUsername --admin-password $adminPassword \
    --vnet-name $vnetName --subnet $subnetName --public-ip-address "" --nsg $nsg
  
  echo "Virtual machine $vmName created successfully!"
}

# Create three virtual machines
create_vm "vm1"
create_vm "vm2"
create_vm "vm3"
create_vm "vm4"
create_vm "vm5"
create_vm "vm6"
create_vm "vm7"
create_vm "vm8"
create_vm "vm9"
