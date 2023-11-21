#!/bin/bash

# Define common variables
resourceGroupName="rglbtest"
location="eastus"
adminUsername="satish"
adminPassword="@Password1234"
vnetName="vnetus"
subnetName="Subnet-1"
# publicIpAddressName="MyPublicIP"
nsgName="NSG12313"
vmSize="Standard_B1s"
image="Ubuntu2204"
# imageSku="20.04-LTS"
customDataFile="cloud-init.txt"

# List of VM names
vmNames=("VM1" "VM2" "VM3")

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a virtual network
az network vnet create --resource-group $resourceGroupName --name $vnetName --subnet-name $subnetName

# Create a public IP address
# az network public-ip create --resource-group $resourceGroupName --name $publicIpAddressName --allocation-method Dynamic

# Create a network security group and open ports 22 (SSH) and 80 (HTTP)
az network nsg create --resource-group $resourceGroupName --name $nsgName
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name allow-ssh --priority 100 --protocol Tcp --destination-port-range 22 --access Allow
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name allow-http --priority 110 --protocol Tcp --destination-port-range 80 --access Allow

# Deploy VMs in a loop
for vmName in "${vmNames[@]}"
do
    echo "Creating VM: $vmName"
    
    # Create the virtual machine with a custom data script
    az vm create --resource-group $resourceGroupName --name $vmName --location $location --size $vmSize --image $image --admin-username $adminUsername --admin-password $adminPassword --public-ip-address "" --nsg $nsgName --vnet-name $vnetName --subnet $subnetName --custom-data $customDataFile
done

echo "VM deployment complete."
