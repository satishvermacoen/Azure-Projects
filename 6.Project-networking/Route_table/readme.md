# Route-Table 

A brief description.

## How to connect a Rout table in vitual network to overwrite system-define-Route and traffic flow with central vitual appliance.



## Diagram

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Route_table/Diagram.png)


## AZURE Service Requried 

1. Route-table
2. Virtual Network
3. 3-Subnet
4. Vitual Machine in each Subnet.
5. Bastion Host(optional)

## What to do.

![App Screenshot](https://github.com/satishvermacoen/Azure-Project-networking/blob/main/Route_table/Diagram2.png)

## To create Route table & and Setup the Setting in it.

```bash
# To create a route table.
az network route-table create \
    --name publictable \
    --resource-group rg-test-rt \
    --disable-bgp-route-propagation false
```
```bash
# To create a custom route.

az network route-table route create \
    --route-table-name publictable \
    --resource-group rg-test-rt \
    --name productionsubnet \
    --address-prefix 10.0.1.0/24 \
    --next-hop-type VirtualAppliance \
    --next-hop-ip-address 10.0.2.4
```
```bash
# To Create a virtual network and subnets.
az network vnet create \
        --name vnet \
        --resource-group rg-test-rt \
        --address-prefixes 10.0.0.0/16 \
        --subnet-name publicsubnet \
        --subnet-prefixes 10.0.0.0/24

az network vnet subnet create \
        --name privatesubnet \
        --vnet-name vnet \
        --resource-group rg-test-rt \
        --address-prefixes 10.0.1.0/24

az network vnet subnet create \
        --name dmzsubnet \
        --vnet-name vnet \
        --resource-group rg-test-rt \
        --address-prefixes 10.0.2.0/24

az network vnet subnet list \
        --resource-group rg-test-rt \
        --vnet-name vnet \
        --output table
```
```bash
# To Associate the route table with the public subnet.

az network vnet subnet update \
        --name publicsubnet \
        --vnet-name vnet \
        --resource-group rg-test-rt \
        --route-table publictable

```
Note: Chnage the Resource group name with your Resource group name.

## To Create an NVA(Network Virtual Applince) and virtual machines

Deploy the network virtual appliance
To build the NVA, deploy an Ubuntu LTS instance.


```bash
az vm create \
    --resource-group rg-test-rt \
    --name nva \
    --vnet-name vnet \
    --subnet dmzsubnet \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password @Password12345
```
Enable IP forwarding for the Azure network interface

Run the following command to get the ID of the NVA network interface.

```bash
NICID=$(az vm nic list \
    --resource-group rg-test-rt \
    --vm-name nva \
    --query "[].{id:id}" --output tsv)

echo $NICID
```
Run the following command to get the name of the NVA network interface.

```bash
NICNAME=$(az vm nic show \
    --resource-group rg-test-rt \
    --vm-name nva \
    --nic $NICID \
    --query "{name:name}" --output tsv)

echo $NICNAME
```
Run the following command to enable IP forwarding for the network interface.

```bash
az network nic update --name $NICNAME \
    --resource-group rg-test-rt \
    --ip-forwarding true
```
Enable IP forwarding in the appliance

Run the following command to save the public IP address of the NVA virtual machine to the variable NVAIP.

```bash
NVAIP="$(az vm list-ip-addresses \
    --resource-group rg-test-rt \
    --name nva \
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
    --output tsv)"

echo $NVAIP
```

Run the following command to enable IP forwarding within the NVA.

```bash
ssh -t -o StrictHostKeyChecking=no azureuser@$NVAIP 'sudo sysctl -w net.ipv4.ip_forward=1; exit;'
```
When prompted, enter the password you used when you created the virtual machine.

## Route traffic through the NVA

```bash
code cloud-init.txt
```
Add the following configuration information to the file. With this configuration, the inetutils-traceroute package is installed when you create a new VM. This package contains the traceroute utility that you'll use later in this exercise.

```bash
#cloud-config
package_upgrade: true
packages:
   - inetutils-traceroute
```
Press Ctrl+S to save the file, and then press Ctrl+Q to close the editor.
 ###  To create vm in private subnet and public subnet.
* Public-VM
```bash
az vm create \
    --resource-group rg-test-rt \
    --name public \
    --vnet-name vnet \
    --subnet publicsubnet \
    --image UbuntuLTS \
    --admin-username azureuser \
    --no-wait \
    --custom-data cloud-init.txt \
    --admin-password <password>
```
* Private-VM
```bash
az vm create \
    --resource-group rg-test-rt \
    --name private \
    --vnet-name vnet \
    --subnet privatesubnet \
    --image UbuntuLTS \
    --admin-username azureuser \
    --no-wait \
    --custom-data cloud-init.txt \
    --admin-password <password>
```
Run the following Linux watch command to check that the VMs are running. The watch command periodically runs the az vm list command so that you can monitor the progress of the VMs.

```bash
watch -d -n 5 "az vm list \
    --resource-group rg-test-rt \
    --show-details \
    --query '[*].{Name:name, ProvisioningState:provisioningState, PowerState:powerState}' \
    --output table"
```
A ProvisioningState value of "Succeeded" and a PowerState value of "VM running" indicate a successful deployment. When all three VMs are running, you're ready to move on. Press Ctrl-C to stop the command and continue with the exercise.

Run the following command to save the public IP address of the public VM to a variable named PUBLICIP.

```bash
PUBLICIP="$(az vm list-ip-addresses \
    --resource-group rg-test-rt \
    --name public \
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
    --output tsv)"

echo $PUBLICIP
```
Run the following command to save the public IP address of the private VM to a variable named PRIVATEIP.

```bash
PRIVATEIP="$(az vm list-ip-addresses \
    --resource-group rg-test-rt \
    --name private \
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
    --output tsv)"

echo $PRIVATEIP
```
Test traffic routing through the network virtual appliance
The final steps use the Linux traceroute utility to show how traffic is routed. You'll use the ssh command to run traceroute on each VM. The first test will show the route taken by ICMP packets sent from the public VM to the private VM. The second test will show the route taken by ICMP packets sent from the private VM to the public VM.


Run the following command to trace the route from public to private. When prompted, enter the password for the azureuser account that you specified earlier.

Bash

```bash
ssh -t -o StrictHostKeyChecking=no azureuser@$PUBLICIP 'traceroute private --type=icmp; exit'
```
If you receive the error message bash: traceroute: command not found, wait a minute and retry the command. The automated installation of traceroute can take a minute or two after VM deployment. After the command succeeds, the output should look similar to the following example:

>traceroute to private.kzffavtrkpeulburui2lgywxwg.gx.internal.cloudapp.net (10.0.1.4), 64 hops max
1.   10.0.2.4  0.710ms  0.410ms  0.536ms
2.   10.0.1.4  0.966ms  0.981ms  1.268ms

Connection to 52.165.151.216 closed.
Notice that the first hop is to 10.0.2.4. 

This address is the private IP address of nva. The second hop is to 10.0.1.4, the address of private. In the first exercise, you added this route to the route table and linked the table to the publicsubnet subnet. So now all traffic from public to private is routed through the NVA.

Route from public to private.

Run the following command to trace the route from private to public. When prompted, enter the password for the azureuser account.

```bash
ssh -t -o StrictHostKeyChecking=no azureuser@$PRIVATEIP 'traceroute public --type=icmp; exit'
```
You should see the traffic go directly to public (10.0.0.4) and not through the NVA, as shown in the following command output.


>traceroute to public.kzffavtrkpeulburui2lgywxwg.gx.internal.cloudapp.net (10.0.0.4), 64 hops max
1.   10.0.0.4  1.095ms  1.610ms  0.812ms

Connection to 52.173.21.188 closed.

The private VM is using default routes, and traffic is routed directly between the subnets.

Route from private to public.

You've now configured routing between subnets to direct traffic from the public internet through the dmzsubnet subnet before it reaches the private subnet. In the dmzsubnet subnet, you added a VM that acts as an NVA. You can configure this NVA to detect potentially malicious requests and block them before they reach their intended targets.
