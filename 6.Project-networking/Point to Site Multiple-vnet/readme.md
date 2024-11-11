# Point to Site VPN Gateway

A brief description.

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/Point%20to%20Site%20Multiple-vnet/Azure%20Virtual%20Network%20Peering.drawio.png)

## AZURE Service Requried 

1. Virtual Network
2. VPN Gateway 
3. Local Area Gateway 
4. Public IP for Gateway

## Create Resource Group

In this exercise, I like to use separate resource group for virtual network and other components.

Log in to Azure portal as global administrator
Launch Cloud Shell

Then run 
```
New-AzureRmResourceGroup -Name REBELVPNRG -Location "East US"
```
In here REBELVPNRG is resource group name and East US is the location.


## Create 

Virtual-Network-1

Now we need to create new virtual network. We can create virtual network using,

```
New-AzureRmVirtualNetwork -ResourceGroupName REBELVPNRG -Name VNET1 -AddressPrefix 10.2.0.0/16 -Location "East US"

```
This is for Virtual-Network-2
```
 New-AzureRmVirtualNetwork -ResourceGroupName REBELVPNRG -Name VNET2 -AddressPrefix 10.0.0.0/16 -Location "Central India"

 ```

In above, REBEL-VNET is the virtual network name. it uses 10.2.0.0/16 IP address range.


## Create Subnets


Under the virtual network I am going to create a subnet for my servers. To create subnet use,

```
$vn1 = Get-AzureRmVirtualNetwork -ResourceGroupName REBELVPNRG -Name VNET1

$vn2 = Get-AzureRmVirtualNetwork -ResourceGroupName REBELVPNRG -Name VNET2

```
```
Add-AzureRmVirtualNetworkSubnetConfig -Name REBEL-SVR-SUB -VirtualNetwork $vn1 -AddressPrefix 10.0.0.0/24

Set-AzureRmVirtualNetwork -VirtualNetwork $vn1

```
```
Add-AzureRmVirtualNetworkSubnetConfig -Name REBEL-SVR-SUB -VirtualNetwork $vn2 -AddressPrefix 10.2.0.0/24

Set-AzureRmVirtualNetwork -VirtualNetwork $vn2

```

## Virtual Network Peering(Global) 

1. Choose the first virtual network to use in the peering, and select Settings > Add (peering).

2. Configure the peering parameters for the first virtual network.

    The top portion of the Add peering dialog shows settings for this virtual network. The bottom portion of the dialog shows settings for the remote virtual network in the peering.

* Peering link name: Provide a name to identify the peering on this virtual network. The name must be unique within the virtual network.

* Traffic to remote virtual network: Specify how to control traffic to the remote virtual network.

* Allow: Allow communication between resources connected to both of your virtual networks within the peered network.

* Block: Block all traffic to the remote virtual network. You can still allow some traffic to the remote virtual network if you explicitly open the traffic through a network security group rule.

* Traffic forwarded from remote virtual network: Specify how to control traffic that originates from outside your remote virtual network.

* Allow: Forward outside traffic in the remote virtual network to this virtual network within the peering. This parameter lets you forward traffic from outside the remote virtual network, such as traffic from an NVA, to this virtual network.

* Block: Block the forwarding of outside traffic from the remote virtual network to this virtual network within the peering. Again, some traffic can still be forwarded by explicitly opening the traffic through a network security group rule. When you configure traffic forwarding between virtual networks through an Azure VPN gateway, this parameter isn't applicable.

* Virtual network gateway or Route Server: Specify whether your virtual network peering should use an Azure VPN gateway. The default is to not use a VPN gateway (None).

* Configure the peering parameters for your remote virtual network.

     In the Azure portal, you configure the remote virtual network in the peering on the Add peering dialog. The bottom portion shows settings for the remote virtual network. The settings are similar to the parameters described for the first virtual network.


3. Create at least one virtual machine in each virtual network.

4. Test communication between the virtual machines within your peered network.


## Create Gateway Subnet

Before we create VN gateway, we need to create gateway subnet for it. so gateway will use ip addresses assigned in this subnet.

To do that,

Log in to Azure portal as global administrator
Go to Virtual Networks | REBEL-VNET (VNet created on previous steps) | Subnets


Click on Gateway Subnet


In new window, define the ip range for gateway subnet and click Ok

Create Virtual Network Gateway

Now we have all the things needed to create new VN gateway. To do that,

Log in to Azure portal as global administrator
Go to All Services and search for virtual network gateway. Once it is in list, click on it.

Then click on Create virtual network gateway


In new window fill relevant info and click on Create
 In here, REBEL-VPN-GW is the gateway name. I have selected REBEL-VNET as the virtual network. I am also creating public ip called REBEL-PUB1. This is only supported with dynamic mode. This doesn’t mean it is going to change randomly. It will only happen when gateway is deleted or read.




## Create Self-sign root & client certificate

If your organization using internal CA, you always can use it to generate relevant certificates for this exercise. If you do not have internal CA, we still can use self-sign certs to do the job.

As first step I am going to create root certificate. In Windows 10 machine I can run this to create root cert first.
```

$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `

-Subject "CN=REBELROOT" -KeyExportPolicy Exportable `

-HashAlgorithm sha256 -KeyLength 2048 `

-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign

```
This will create root cert and install it under current user cert store.




Then we need to create client certificate. We can do this using
```
New-SelfSignedCertificate -Type Custom -DnsName REBELCLIENT -KeySpec Signature `
-Subject "CN=REBELCLIENT" -KeyExportPolicy Exportable `

-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

```

This will create cert called REBELCLIENT and install in same store location.


Now we have certs in place. But we need to export these so we can upload it to Azure.

To export root certificate,

Right click on root cert inside certificate mmc.
Click on ExportIn private key page, select not to export private key


Select Base-64 encoded X.509 as export file format.


Complete the wizard and save the cert in pc.
 To export client certificate,


Use same method to export as root cert, but this time under private key page, select option to export private key.

In file format page, leave the default as following and click Next

Define password for the pfx file and complete the wizard.

Note – Only root cert will use in Azure VPN, client certificate can install on other computers which need P2S connections.


## Configure Point-to-Site Connection


Next step of this configuration is to configure the point-to-site connection. In here we will define client ip address pool as well. It is for VPN clients.


Click on newly created VPN gateway connection.
Then in new window click on Point-to-site configuration

After that, click on Configure Now


In new window type IP address range for VPN address pool. In this demo I will be using 172.16.25.0/24. For tunnel type use both SSTP & IKEv2. Linux and other mobile clients by default use IKEv2 to connect. Windows also use IKEv2 first and then try SSTP. For authentication type use Azure Certificates.


In same window there is place to define root certificate. Under root certificate name type the cert name and under public certificate data, paste the root certificate data ( you can open cert in notepad to get data).


Then click on Save to complete the process.


Note : when you paste certificate data, do not copy -----BEGIN CERTIFICATE----- & -----END CERTIFICATE----- text.


## Testing VPN connection

Now we have finished with configuration. As next step, we need to test the connection. To do that log in to the same pc where we generate certificates. If you going to use differentPC, first you need to import root cert & client certificate we exported.

Log in to Azure portal from machine and go to VPN gateway config page.
In that page, click on Point-to-site configurationAfter that, click on Download VPN client


Then double click on the VPN client setup. In my case I am using 64bit vpn client.


After that, we can see new connection under windows 10 VPN page.


Click on connect to VPN. Then it will open up this new window. Click on Connect in there.

Then run ip config to verify ip allocation from VPN address pool.

In VPN gateway page also, I can see one connection is made.

First we 

    Take RDP- of Virtual Machine of V-net2 with there private ip 10.0.0.4

After that 

    Take RDP- of Virtual Machine of V-net1 with there private ip 10.2.0.4



As expected, I can RDP to this via VPN.

