#!/bin/bash

RgName=`az group list --query '[0].name' --output tsv`
Location=`az group list --query '[0].location' --output tsv`

date
# Create a Virtual Network for the VMs
echo '------------------------------------------'
echo 'Creating a Virtual Network for the VMs'
az network vnet create \
    --resource-group $RgName \
    --location $Location \
    --name bePortalVnet \
    --subnet-name bePortalSubnet 

# Create a Network Security Group
echo '------------------------------------------'
echo 'Creating a Network Security Group'
az network nsg create \
    --resource-group $RgName \
    --name bePortalNSG \
    --location $Location

az network nsg rule create -g $RgName --nsg-name bePortalNSG -n AllowAll80 --priority 101 \
                            --source-address-prefixes 'Internet' --source-port-ranges '*' \
                            --destination-address-prefixes '*' --destination-port-ranges 80 --access Allow \
                            --protocol Tcp --description "Allow all port 80 traffic"


# Create the NIC
for i in `seq 1`; do
  echo '------------------------------------------'
  echo 'Creating webNic'$i
  az network nic create \
    --resource-group $RgName \
    --name webNic$i \
    --vnet-name bePortalVnet \
    --subnet bePortalSubnet \
    --network-security-group bePortalNSG \
    --location $Location
done 

# Create VM's from a template
for i in `seq 1`; do
    echo '------------------------------------------'
    echo 'Creating webVM'$i
    az vm create \
        --admin-username satish \
        --admin-password @Password123 \
        --resource-group $RgName \
        --name webVM$i \
        --nics webNic$i \
        --location $Location \
        --size Standard_B1s \
        --image UbuntuLTS \
        --public-ip-address web-ip \
        --custom-data cloud-init.txt
done

# Done
echo '--------------------------------------------------------'
echo '             VM Setup Completed'
echo '--------------------------------------------------------'
