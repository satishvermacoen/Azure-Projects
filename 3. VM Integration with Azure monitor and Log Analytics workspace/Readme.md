# How to Integration with Azure Monitor Azure Virtual Machines (VMs Linux)

Integrating Azure Monitor with Azure Virtual Machines (VMs) running Linux involves configuring the Azure Monitor Agent on the VMs. The Azure Monitor Agent collects performance data, logs, and other telemetry from the VMs and sends this data to Azure Monitor. Here are the steps to integrate Azure Monitor with Azure VMs running Linux:
### OVERVIEW
![Overview](https://github.com/satishvermacoen/Azure-Projects/blob/main/3.%20VM%20Integration%20with%20Azure%20monitor%20and%20Log%20Analytics%20workspace/img/3.VM-Integration%20with%20Azure%20Monitor.png)

## Prerequisites:

- An Azure subscription.
- Azure VMs running Linux.
- Appropriate permissions to install software and configure the VMs.


doc-https://learn.microsoft.com/en-us/azure/azure-monitor/agents/agent-linux?tabs=wrapper-script

Python requirement
Starting from agent version 1.13.27, the Linux agent will support both Python 2 and 3. We always recommend that you use the latest agent.

If you're using an older version of the agent, you must have the virtual machine use Python 2 by default. If your virtual machine is using a distro that doesn't include Python 2 by default, then you must install it. The following sample commands will install Python 2 on different distros:

- Red Hat, CentOS, Oracle:
```Bash
   sudo yum install -y python2
```
- Ubuntu, Debian:
```Bash
   sudo apt-get update
   
   sudo apt-get install -y python2
```
- SUSE:
```Bash
   sudo zypper install -y python2
```
Again, only if you're using an older version of the agent, the python2 executable must be aliased to python. Use the following method to set this alias:

Run the following command to remove any existing aliases:

```Bash
sudo update-alternatives --remove-all python
```
Run the following command to create the alias:

```Bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2
```

Step 1: Install the Azure Monitor Agent on Linux VMs

Connect to the VM: You can connect to your Linux VM using SSH. You should have administrative privileges to install the agent.

Download the Azure Monitor Agent:

You can download the agent package from the Azure Monitor extension repository.

```bash
wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w <YOUR WORKSPACE ID> -s <YOUR WORKSPACE PRIMARY KEY> -d opinsights.azure.us
```
Configure the WORKSPACE_ID and WORKSPACE_KEY with the values of your Log Analytics workspace.
Restart the Agent:

After Installation of agent, restart it to apply the changes.

```bash
sudo /opt/microsoft/omsagent/bin/service_control restart [<workspace id>]
```
Step 2: Verify Integration

Verify the Agent Status:
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/3.%20VM%20Integration%20with%20Azure%20monitor%20and%20Log%20Analytics%20workspace/img/done.png)
Access Data in Azure Monitor:

In the Azure Portal, go to your Log Analytics workspace, and you should see data coming in from the Linux VMs.
Step 3: Configure Data Collection (Optional)

You can further configure what data is collected and sent from the Linux VMs by modifying the agent configuration. The agent allows you to collect performance data, logs, and custom data based on your requirements.

By following these steps, you can integrate Azure Monitor with Azure Virtual Machines running Linux and collect valuable telemetry data for monitoring, diagnostics, and analysis. This integration is essential for maintaining the performance and health of your VMs and applications.