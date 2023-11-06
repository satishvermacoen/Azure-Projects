# How to Integration with Azure Monitor Azure Virtual Machines (VMs Linux)

Integrating Azure Monitor with Azure Virtual Machines (VMs) running Linux involves configuring the Azure Monitor Agent on the VMs. The Azure Monitor Agent collects performance data, logs, and other telemetry from the VMs and sends this data to Azure Monitor. Here are the steps to integrate Azure Monitor with Azure VMs running Linux:
### OVERVIEW
![Overview](https://github.com/satishvermacoen/Azure-Projects/blob/main/2.%20Azure%20VM%20Deployment%20with%20cloud%20init/img/draw.png)

## Prerequisites:

- An Azure subscription.
- Azure VMs running Linux.
- Appropriate permissions to install software and configure the VMs.

Step 1: Install the Azure Monitor Agent on Linux VMs

Connect to the VM: You can connect to your Linux VM using SSH. You should have administrative privileges to install the agent.

Download the Azure Monitor Agent:

You can download the agent package from the Azure Monitor extension repository.

```bash
wget https://github.com/microsoft/OMS-Agent-for-Linux/releases/download/1.13.30-0/omsagent-1.13.30-0.universal.x64.sh
```
Ensure that you download the appropriate version of the agent for your Linux distribution.
Install the Agent:

Run the following command to install the Azure Monitor Agent:
```bash
sudo sh ./omsagent-*.universal.x64.sh --install -w <workspace-id> -s <workspace-key>
```
Replace <workspace-id> with your Log Analytics workspace ID.
Replace <workspace-key> with the Log Analytics workspace primary key.
Configure the Agent:

After the installation is complete, the agent needs to be configured. Edit the agent configuration file, usually located at /etc/opt/microsoft/omsagent/<workspace-id>/conf/omsagent.conf.

```bash
sudo vi /etc/opt/microsoft/omsagent/<workspace-id>/conf/omsagent.conf
```
Configure the WORKSPACE_ID and WORKSPACE_KEY with the values of your Log Analytics workspace.
Restart the Agent:

After configuring the agent, restart it to apply the changes.

```bash
sudo /opt/microsoft/omsagent/bin/service_control restart
```
Step 2: Verify Integration

Verify the Agent Status:

To check the agent's status, you can run the following command:

```bash
sudo /opt/microsoft/omsagent/bin/omsadmin.sh -l
```
This command should display information about the agent's status and the workspace it's connected to.
Access Data in Azure Monitor:

In the Azure Portal, go to your Log Analytics workspace, and you should see data coming in from the Linux VMs.
Step 3: Configure Data Collection (Optional)

You can further configure what data is collected and sent from the Linux VMs by modifying the agent configuration. The agent allows you to collect performance data, logs, and custom data based on your requirements.

By following these steps, you can integrate Azure Monitor with Azure Virtual Machines running Linux and collect valuable telemetry data for monitoring, diagnostics, and analysis. This integration is essential for maintaining the performance and health of your VMs and applications.