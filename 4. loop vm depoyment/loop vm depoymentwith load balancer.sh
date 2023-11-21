#!/bin/bash

# Define variables
resourceGroupName="rglbtest"
location="eastus"
vmPrefix="MyVM"  # Prefix for VM names
adminUsername="azureuser"
adminPassword="@Password1234"
vnetName="vnet-01"
subnetName="subnet-1"
subnetName="subnet-2"
subnetName="subnet-3"
publicIpAddressName="MyPublicIP"
nsgName="MyNSG"
vmSize="Standard_B1s"
imageOffer="Ubuntu2204"
customDataFile="cloud-init.txt"
loadBalancerName="MyLoadBalancer"
frontendIPName="myFrontEnd"
backendPoolName="myBackEndPool"
probeName="myHealthProbe"
lbRuleName="myLBRules"

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a virtual network
az network vnet create --resource-group $resourceGroupName --name $vnetName --location $location --address-prefixes 10.2.0.0/16

# Create a subnet
az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --address-prefixes 10.2.1.0/24

az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --address-prefixes 10.2.2.0/24

az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --address-prefixes 10.2.3.0/24

# Create a public IP address
az network public-ip create --resource-group $resourceGroupName --name $publicIpAddressName --allocation-method Static

# Create a network security group and open ports 22 (SSH) and 80 (HTTP)
az network nsg create --resource-group $resourceGroupName --name $nsgName
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name allow-ssh --priority 100 --protocol Tcp --destination-port-range 22 --access Allow
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name allow-http --priority 110 --protocol Tcp --destination-port-range 80 --access Allow

# Create a load balancer with a health probe and load balancing rule
az network lb create --resource-group $resourceGroupName --name $loadBalancerName --location $location
az network lb frontend-ip create --resource-group $resourceGroupName --lb-name $loadBalancerName --name $frontendIPName --public-ip-address $publicIpAddressName
az network lb probe create --resource-group $resourceGroupName --lb-name $loadBalancerName --name $probeName --protocol Tcp --port 80
az network lb rule create --resource-group $resourceGroupName --lb-name $loadBalancerName --name $lbRuleName --protocol Tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $frontendIPName --backend-pool-name $backendPoolName --probe-name $probeName

# Deploy two VMs with load balancer

# Create the virtual machine with a custom data script and add to backend pool
az vm create --resource-group $resourceGroupName --name $vmName --location $location --size $vmSize --image $imageOffer --admin-username $adminUsername --admin-password $adminPassword --public-ip-address "" --nsg $nsgName --vnet-name $vnetName --subnet $subnetName --custom-data $customDataFile

# Add VM to the load balancer backend pool
az network nic ip-config address-pool add --resource-group $resourceGroupName --lb-name $loadBalancerName --name ipconfig$i --nic-name "${vmName}VMNic" --address-pool $backendPoolName
done

echo "VM deployment with load balancer complete."
