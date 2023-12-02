# create shell variables
resourceGroup=VMTutorialResources
location=eastus

az group create --name $resourceGroup --location $location

# create shell variables
vnetName=TutorialVNet1
subnetName=TutorialSubnet1
vnetAddressPrefix=10.0.0.0/16
subnetAddressPrefix=10.0.0.0/24

az network vnet create \
  --name $vnetName \
  --resource-group $resourceGroup \
  --address-prefixes $vnetAddressPrefix \
  --subnet-name $subnetName \
  --subnet-prefixes $subnetAddressPrefix


# create shell variables

vmName=TutorialVM1

az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --image UbuntuLTS \
  --vnet-name $vnetName \
  --subnet $subnetName \
  --generate-ssh-keys \
  --output json \
  --verbose

## Parrmeter of Virtual Machine

az vm create 
  --name
  --resource-group
  --accelerated-networking {false, true} 
  --accept-term 
  --admin-password 
  --admin-username 
  --asgs 
  --assign-identity 
  --attach-data-disks 
  --attach-os-disk 
  --authentication-type {all, password, ssh} 
  --availability-set 
  --boot-diagnostics-storage 
  --capacity-reservation-group 
  --computer-name 
  --count 
  --custom-data 
  --data-disk-caching 
  --data-disk-delete-option 
  --data-disk-encryption-sets 
  --data-disk-sizes-gb 
  --disable-integrity-monitoring 
  --disk-controller-type {NVMe, SCSI} 
  --edge-zone 
  --enable-agent {false, true} 
  --enable-auto-update {false, true} 
  --enable-hibernation {false, true} 
  --enable-hotpatching {false, true} 
  --enable-secure-boot {false, true} 
  --enable-vtpm {false, true} 
  --encryption-at-host {false, true} 
  --ephemeral-os-disk {false, true} 
  --ephemeral-os-disk-placement {CacheDisk, ResourceDisk} 
  --eviction-policy {Deallocate, Delete} 
  --generate-ssh-keys 
  --host 
  --host-group 
  --image 
  --license-type {None, RHEL_BASE, RHEL_BASESAPAPPS, RHEL_BASESAPHA, RHEL_BYOS, RHEL_ELS_6, RHEL_EUS, RHEL_SAPAPPS, RHEL_SAPHA, SLES, SLES_BYOS, SLES_HPC, SLES_SAP, SLES_STANDARD, UBUNTU, UBUNTU_PRO, Windows_Client, Windows_Server} 
  --location 
  --max-price 
  --nic-delete-option 
  --nics 
  --no-wait 
  --nsg 
  --nsg-rule {NONE, RDP, SSH} 
  --os-disk-caching {None, ReadOnly, ReadWrite} 
  --os-disk-delete-option {Delete, Detach} 
  --os-disk-encryption-set 
  --os-disk-name 
  --os-disk-secure-vm-disk-encryption-set 
  --os-disk-security-encryption-type {DiskWithVMGuestState, VMGuestStateOnly} 
  --os-disk-size-gb 
  --os-type {linux, windows} 
  --patch-mode {AutomaticByOS, AutomaticByPlatform, ImageDefault, Manual} 
  --plan-name 
  --plan-product 
  --plan-promotion-code 
  --plan-publisher 
  --platform-fault-domain 
  --ppg 
  --priority {Low, Regular, Spot} 
  --private-ip-address 
  --public-ip-address 
  --public-ip-address-allocation {dynamic, static} 
  --public-ip-address-dns-name 
  --public-ip-sku {Basic, Standard} 
  --role 
  --scope 
  --secrets 
  --security-type {ConfidentialVM, TrustedLaunch} 
  --size 
  --specialized {false, true} 
  --ssh-dest-key-path 
  --ssh-key-name 
  --ssh-key-values 
  --storage-account 
  --storage-container-name 
  --storage-sku 
  --subnet 
  --subnet-address-prefix 
  --tags 
  --ultra-ssd-enabled {false, true} 
  --use-unmanaged-disk 
  --user-data 
  --v-cpus-available 
  --v-cpus-per-core 
  --validate 
  --vmss 
  --vnet-address-prefix 
  --vnet-name 
  --workspace 
  --zone {1, 2, 3} 

# To Login into Virtual Machine

  ssh <PUBLIC_IP_ADDRESS>
#The common command for getting information from a resource is show

  az vm show --name $vmName --resource-group $resourceGroup
# In order to extract the object ID we want, the --query argument is used.

az vm show --name $vmName \
  --resource-group $resourceGroup \
  --query 'networkProfile.networkInterfaces[].id' \
  --output tsv
# Go ahead and assign the NIC object ID to an shell variable now.

nicId=$(az vm show \
  -n $vmName \
  -g $resourceGroup \
  --query 'networkProfile.networkInterfaces[].id' \
  -o tsv)

# Now that you have the NIC ID, run az network nic show to get its information.

az network nic show --ids $nicId

# This command shows all of the information for the network interface of the VM.
  az network nic show --ids $nicId \
  --query '{IP:ipConfigurations[].publicIpAddress.id, Subnet:ipConfigurations[].subnet.id}' \
  -o json

# In order to use command-line tools, change the command to remove the custom JSON keys and output as tsv.

read -d '' ipId subnetId <<< $(az network nic show \
  --ids $nicId \
  --query '[ipConfigurations[].publicIpAddress.id, ipConfigurations[].subnet.id]' \
  -o tsv)

# Use the public IP object ID to look up the public IP address and store it in a shell variable.
vmIpAddress=$(az network public-ip show --ids $ipId \
  --query ipAddress \
  -o tsv)
# Now you have the IP address of the VM stored in a shell variable.

  echo $vmIpAddress

# To Delete Resource-Group command

az group delete --name $resourceGroup --no-wait

az group wait --name $resourceGroup --deleted
