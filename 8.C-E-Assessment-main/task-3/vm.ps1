New-AzResourceGroup -Name flaskapp -Location eastus

$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

$vm1 = 
@{
ResourceGroupName = 'flaskapp'
Name = 'VM1'
Location = 'eastus'
ImageName = 'ubuntu_lastest'
PublicIpAddressName = 'tutorialPublicIp'
Credential = $cred
OpenPorts = 22, 80
Size = 'Standard_B1s'
}

$newVM1 = New-AzVM @vm1

$newVM1.OSProfile | Select-Object -Property ComputerName,AdminUserName                                                                                                                                                  ComputerName AdminUsername                                                                                           ------------ -------------                                                                                           TutorialVM1  satish                                                                                                                                                                                                                       
$newVM1 | Get-AzNetworkInterface |
  Select-Object -ExpandProperty IpConfigurations |
    Select-Object -Property Name, PrivateIpAddress

$publicIp = Get-AzPublicIpAddress -Name tutorialPublicIp -ResourceGroupName TutorialResources

$publicIp |
    Select-Object -Property Name, IpAddress, @{label='FQDN';expression={$_.DnsSettings.Fqdn}}

mstsc.exe /v $publicIp.IpAddress

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


$job = Remove-AzResourceGroup -Name TutorialResources -Force -AsJob

$job

Wait-Job -Id $job.Id