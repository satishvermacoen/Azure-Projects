Connect-AzConnect

# To Create a Resource Group
New-AzResourceGroup -Name TutorialResources -Location eastus

# To Create admin credentials for the VM
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# To Create a virtual machine

$vmParams = @{
    ResourceGroupName = 'ResourceGroup01'
    Name = 'vm01'
    Location = 'centralindia'
    ImageName = 'Win2016Datacenter'
    PublicIpAddressName = 'ip53PublicIp'
    Credential = $cred
    OpenPorts = 3389, 80, 443
    Size = 'Standard_B1'
  }
  $newVM1 = New-AzVM @vmParams

  $newVM1

 # To Get VM information with queries
 
 $newVM1.OSProfile | Select-Object -Property ComputerName,AdminUserName

 # To get specific information about the network configuration.

 $newVM1 | Get-AzNetworkInterface |
  Select-Object -ExpandProperty IpConfigurations |
    Select-Object -Property Name, PrivateIpAddress

# To confirm that the VM is running, we need to connect via Remote Desktop. For that, we need to know the Public IP address.
$publicIp = Get-AzPublicIpAddress -Name tutorialPublicIp -ResourceGroupName TutorialResources

$publicIp |
  Select-Object -Property Name, IpAddress, @{label='FQDN';expression={$_.DnsSettings.Fqdn}}

  mstsc.exe /v $publicIp.IpAddress

# To Creating a new VM on the existing subnet

$vm2Params = @{
    ResourceGroupName = 'TutorialResources'
    Name = 'TutorialVM2'
    ImageName = 'Win2016Datacenter'
    VirtualNetworkName = 'TutorialVM1'
    SubnetName = 'TutorialVM1'
    PublicIpAddressName = 'tutorialPublicIp2'
    Credential = $cred
    OpenPorts = 3389
  }
  $newVM2 = New-AzVM @vm2Params
  
  $newVM2

  mstsc.exe /v $newVM2.FullyQualifiedDomainName

  # To Clean Up

  $job = Remove-AzResourceGroup -Name TutorialResources -Force -AsJob

$job

Wait-Job -Id $job.Id    
