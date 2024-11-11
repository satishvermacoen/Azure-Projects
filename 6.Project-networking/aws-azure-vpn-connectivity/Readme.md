
# AWS-AZURE-VPN

A brief description.


##

## How to connect AWS-VPC with AZURE-Virtual Network use of VPN tunneling.



## Diagram

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/draw.png)


### AZURE Service Requried 

1. Virtual Network
2. VPN Gateway 
3. Local Area Gateway 
4. Public IP for Gateway



### AWS Service Requried
1. VPC
2. Customer Gateway
3. Virtual Private Gateway
4. Site-to-Site connection



## Configuring Azure
1. Crate a resource group on Azure to deploy the resources on that
Choose the subscription, the name and the region to be deployed.

2. Create a Virtual Network and a subnet
Define the subscription, resource group, name and region to be deployed.
Set the address space for the virtual network and for the subnet. Here I'm defining the virtual network address space to 10.0.0.0/16, changing the "default" subnet name to "my-subnet-azure-aws-01" and defining the subnet address range to 10.0.0.0/24.

3. Create the VPN Gateway

The Azure VPN Gateway is a resource composed of 2 or more VM's that are deployed to a specific subnet called Gateway Subnet where the recommendation is to use a /24. He contain routing tables and run specific gateway services. Note that you can't access those VM's.

To create, go to your Resource Group, then click to + Add
Then fill the fields like below.
After click to Review + create, in a few minutes the Virtual Network Gateway will be ready.



## Configuring AWS

4. Create the Virtual Private Cloud (VPC)

5. Create a subnet inside the VPC (Virtual Network)

6. Create a customer gateway pointing to the public ip address of Azure VPN Gateway

The Customer Gateway is an AWS resource with information to AWS about the customer gateway device, which in this case is the Azure VPN Gateway.

7. Create the Virtual Private Gateway then attach to the VPC

8. Create a site-to-site VPN Connection
Set the routing as static pointing to the azure subnet-01 prefix (172.10.1.0/24)
After fill the options, click to create.

9. Download the configuration file

Please note that you need to change the Vendor, Platform and Software to Generic since Azure isn't a valid option.
In this configuration file you will note that there are the Shared Keys and the Public Ip Address for each of one of the two IPSec tunnels created by AWS.
After the creation, you should have something like this.
Adding the AWS information on Azure Configuration

10. Now let’s create the Local Network Gateway
The Local Network Gateway is an Azure resource with information to Azure about the customer gateway device, in this case the AWS Virtual Private Gateway
Now you need to specify the public ip address from the AWS Virtual Private Gateway and the VPC CIDR prefix.

Please note that the public address from the AWS Virtual Private Gateway is described at the configuration file you have downloaded.

As mentioned earlier, AWS creates two IPSec tunnels to high availability purposes. I'll use the public ip address from the IPSec Tunnel #1 for now.

11. Then let's create the connection on the Virtual Network Gateway
You should fill the fields according below. Please note that the Shared key was obtained at the configuration file downloaded earlier and In this case, I'm using the Shared Key for the Ipsec tunnel #1 created by AWS and described at the configuration file.
After a few minutes, you can see the connection established.
In the same way, we can check on AWS that the 1st tunnel is up.
Now let's edit the route table associated with our VPC
And add the route to Azure subnet through the Virtual Private Gateway.

12. Adding high availability

Now we can create a 2nd connection to ensure high availability. To do this let's create another Local Network Gateway which we will point to the public ip address of the IPSec tunnel #2 on the AWS
Then we can create the 2nd connection on the Virtual Network Gateway.
And in a few moments we'll have.
With this, our VPN connection is established on both sides and the work is done.

13. Let's test!

First, let's add an Internet Gateway to our VPC at AWS. The Internet Gateway is a logical connection between an Amazon VPN and the Internet. This resource will allow us to connect through the test VM from their public ip through internet. This is not required for the VPN connection, is just for our test.
After create, let's attach to the VPC.
Now we can create a route to allow connections to 0.0.0.0/0 (Internet) through the Internet Gateway.
On Azure the route was automatically created. You can check selecting the Azure VM > Networking > Network Interface > Effective routes. Note that we have 2 (1 per connection).
Now I've created a Linux VM on Azure and our environment looks like this.
And I did the same VM creation on AWS that looks like this.
Then we can test the connectivity betweeen Azure and AWS through our VPN connection



## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(23).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(22).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(21).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(20).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(19).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(18).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(17).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(16).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(15).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(14).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(13).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(12).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(11).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(10).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(28).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(27).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(26).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(25).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(24).png)

Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(8).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(7).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(6).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(5).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(4).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(3).png)

## Screenshots

![App Screenshot](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/Screenshot%20(2).png)