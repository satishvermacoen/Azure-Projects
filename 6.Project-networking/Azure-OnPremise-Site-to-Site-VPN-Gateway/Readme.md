# Site to Site VPN-connection with on-premise
![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/diagram.png)

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(70).png)
## Service Requried 

1. Virtual Network(10.0.0.0/16)
2. VPN Gateway 
3. Local Area Gateway 
4. Public IP for Gateway
5. Integrating with your VPN device
6. Creating the site-to-site VPN tunnel
7. On-premise network(172.31.0.0/24)

### Create a virtual network
In this section, you'll create a virtual network (VNet) using the following values:

Resource group: azuresite
Name: azure-vm-vnet
Region: (US) central india
IPv4 address space: 10.0.0.0/16
Subnet name: FrontEnd
Subnet address space: 10.0.0.0/24

### Create a VPN gateway

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(64).png)

1. In this step, you create the virtual network gateway for your VNet. Creating a gateway can often take 45 minutes or more, depending on the selected gateway SKU.

2. The virtual network gateway uses specific subnet called the gateway subnet. The gateway subnet is part of the virtual network IP address range that you specify when configuring your virtual network. It contains the IP addresses that the virtual network gateway resources and services use.

3. When you create the gateway subnet, you specify the number of IP addresses that the subnet contains. The number of IP addresses needed depends on the VPN gateway configuration that you want to create. Some configurations require more IP addresses than others. It's best to specify /27 or larger (/26,/25 etc.) for your gateway subnet.

4. If you see an error that specifies that the address space overlaps with a subnet, or that the subnet isn't contained within the address space for your virtual network, check your VNet address range. You may not have enough IP addresses available in the address range you created for your virtual network. For example, if your default subnet encompasses the entire address range, there are no IP addresses left to create additional subnets. You can either adjust your subnets within the existing address space to free up IP addresses, or specify an additional address range and create the gateway subnet there.

Create the gateway
Create a virtual network gateway (VPN gateway) using the following values:

Name: site-to-site-hyper-v
Region: central india
Gateway type: VPN
VPN type: Route-based
SKU: Basic
Generation: Generation 1
Virtual network: azure-vm-vnet
Gateway subnet address range: 10.0.255.0/27
Public IP address: Create new
Public IP address name: azuresiteip
Enable active-active mode: Disabled
Configure BGP: Disabled

### Create a local network gateway
The local network gateway is a specific object that represents your on-premises location (the site) for routing purposes. You give the site a name by which Azure can refer to it, then specify the IP address of the on-premises VPN device to which you'll create a connection. You also specify the IP address prefixes that will be routed through the VPN gateway to the VPN device. The address prefixes you specify are the prefixes located on your on-premises network. If your on-premises network changes or you need to change the public IP address for the VPN device, you can easily update the values later.

Create a local network gateway using the following values:

Resource Group: azuresite
Location: Central india

Instance details
Name: Sitetoonpremiselng
Endpoint :IP address
IP address: public ip of onsite
Address Space: 172.31.0.0/24

### Create VPN connections
Create a site-to-site VPN connection between your virtual network gateway and your on-premises VPN device.

Create a connection using the following values:

Connection type: Select Site-to-site (IPSec).
Name: Name your connection.
Region: Select the region for this connection.
Select Settings to navigate to the settings page.

Virtual network gateway: Select the virtual network gateway from the dropdown.
Local network gateway: Select the local network gateway from the dropdown.
Shared Key: the value here must match the value that you're using for your local on-premises VPN device.
Select IKEv2.
Leave Use Azure Private IP Address deselected.
Leave Enable BGP deselected.
Leave FastPath deselected.
IPse/IKE policy: Default.
Use policy based traffic selector: Disable.
DPD timeout in seconds: 45
Connection Mode: leave as Default.
For NAT Rules Associations, leave both Ingress and Egress as 0 selected.

Select Review + create to validate your connection settings.

Select Create to create the connection.

Once the deployment is complete, you can view the connection in the Connections page of the virtual network gateway. The Status goes from Unknown to Connecting, and then to Succeeded.


### Next Setting on On-premise-site


![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(65).png)

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(66).png)

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(67).png)

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(68).png)

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Azure-OnPremise-Site-to-Site-VPN-Gateway/img/Screenshot%20(69).png)
