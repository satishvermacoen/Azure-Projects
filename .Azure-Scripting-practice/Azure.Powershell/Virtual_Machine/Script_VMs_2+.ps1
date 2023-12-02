# Set your Azure subscription ID and resource group name
$subscriptionId = "YOUR_SUBSCRIPTION_ID"
$resourceGroupName = "BackupTest"

# Set the Azure region for the virtual machines
$location = "centralindia"

# Set the names for the virtual machines
$vmNames = @("VM1", "VM2", "VM3")

# Set the virtual machine sizes
$vmSizes = @("Standard_B1s", "Standard_B1s", "Standard_B1s")

# Set the credentials for the virtual machines
$adminUsername = "satish"
$adminPassword = "@Password12345"

# Create a resource group if it doesn't exist
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Iterate through the virtual machine names and create them
for ($i = 0; $i -lt $vmNames.Length; $i++) {
    $vmName = $vmNames[$i]
    $vmSize = $vmSizes[$i]

    # Create a virtual network
    $vnetName = $vmName + "-vnet"
    $vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix "10.0.$i.0/24"

    # Create a subnet
    $subnetName = $vmName + "-subnet"
    $subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -AddressPrefix "10.0.$i.0/24"

    # Create a public IP address
    $publicIpName = $vmName + "-publicip"
    $publicIp = New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

    # Create a network interface
    $nicName = $vmName + "-nic"
    $nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $location -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id

    # Create a virtual machine configuration
    $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
    $vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential (Get-Credential -UserName $adminUsername -Password $adminPassword)
    $vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

    # Create the virtual machine
    New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig
}

Write-Host "Virtual machines created successfully!"
