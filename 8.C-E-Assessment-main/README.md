# Claw-Enterprises---Cloud-Engineer-Assessment

## Task 1


### VNet, Ubuntu VM, and Secure Configuration

1. Set up a Virtual Network (VNet) in Azure.
![App Screenshot](./task-1/Screenshot%20(3).png)

2. Deploy an Ubuntu VM within the VNet.
![App Screenshot](./task-1/Screenshot%20(4).png)
![App Screenshot](./task-1/Screenshot%20(6).png)

3. Ensure the VM is accessible via SSH, but use Network Security Groups (NSGs) to restrict access to only your IP address.
- I done this as showing in the screenshot. but  i am working with wifi network, in which ip changing regularly so i change it "any to any"
![App Screenshot](./task-1/Screenshot%20(7).png)

4. Keep the inbound ports for HTTP and HTTPS open and publicly accessible.
![App Screenshot](./task-1/Screenshot%20(9).png)


### Additional Requirements:

- Enable Azure Security Center for the VM.
- Configure a custom DNS server for the VNet.

## Task 2.

### Advanced Storage Solution

1. Create an Azure storage account.
![App Screenshot](./task-2/Screenshot%20(10).png)
2. Set up an Azure CLI on the VM
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```
![App Screenshot](./task-2/Screenshot%20(8).png)
3. From your Ubuntu VM, upload the index.html to the container.
- To copy from VM to Azure Storage Account Container , We are using AzCopy tool.
- we need to install and config the AzCopy Tool-[Documentation](https://gist.github.com/aessing/76f1200c9f5b2b9671937b3b0ed5fd6f)
```bash
# Download and extract
wget https://aka.ms/downloadazcopy-v10-linux
tar -xvf downloadazcopy-v10-linux

# Move AzCopy
sudo rm -f /usr/bin/azcopy
sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/
sudo chmod 755 /usr/bin/azcopy

# Clean the kitchen
rm -f downloadazcopy-v10-linux
rm -rf ./azcopy_linux_amd64_*/
```
- To make container in the Storage account
```bash
azcopy make "https://clawenterprisesstorage1.blob.core.windows.net/claw-enterprises-container?sv=2022-11-02&ss=bfqt&srt=sc&sp=rwdlacupiytfx&se=2024-07-17T00:43:51Z&st=2024-07-15T15:43:51Z&spr=https&sig=xsbnzef297hWDKCLMAbSfrIKNlxHmEI%2Foms%2BRTVikSc%3D"
```
![App Screenshot](./task-2/Screenshot%20(13).png)
- To copy index.html file from VM to Storage account container

```bash
azcopy copy "/home/satish/html/index.html" "https://clawenterprisesstorage1.blob.core.windows.net/claw-enterprises-container?sp=racwdli&st=2024-07-15T17:25:24Z&se=2024-07-16T06:29:00Z&spr=https&sv=2022-11-02&sr=c&sig=wfACrylkB7Ri55xORjmG0kP0Z5SU%2FpbhYEgW24cs5ak%3D"
```
![App Screenshot](./task-2/Screenshot%20(16).png)


## Task 3.

### Advanced Application Deployment

1. Fork the example repository [here](https://github.com/render-examples/flask-hello-world/tree/master).

2. Deploy the code on the VM.
- Install Required Dependencies
Flask is a python-based application. So Python and other required dependencies must be installed on your server. If not installed you can install all of them with the following command:

```bash
apt-get install python3 python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools -y


```
Error message:
```
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.

    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.

    If you wish to install a non-Debian packaged Python application,
    it may be easiest to use pipx install xyz, which will manage a
    virtual environment for you. Make sure you have pipx installed.

    See /usr/share/doc/python3.12/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.

```
Solution:-
```bash
apt install pipx

pipx install some-python-application
```
Once all the dependencies are installed, install the Python virtual environment package using the following command:

```bash
apt-get install python3-venv -y
```

3. Create a system service to automatically start the application whenever the VM restarts.
4. Configure NGINX as a reverse proxy for the Flask application.

![App Screenshot](./task-3/Screenshot%20(46).png) 
![App Screenshot](./task-3/Screenshot%20(47).png)

### Task-3, I try 3 to 4 times in Virtual Machine and take my reference from many website.
final oon 18-7-2024 i delete my last VM.
![App Screenshot](./task-3/Screenshot%20(51).png) 
 for screenshot [click](./task-3)
--------------------
I try one more time and this is result and also build the pipeline.
![App Screenshot](./task-3/Screenshot%20(37).png)
![App Screenshot](./task-3/Screenshot%20(14).png)
--------------------
## Task 4.

```bash
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install Apache (Ubuntu version)
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
```

1. Create another VM named `hello world`and run the above script on it.
- I create vm name "claw-vm-task4" and run the above script in it.
![App Screenshot](./task-4/Screenshot%20(1).png)
![App Screenshot](./task-4/Screenshot%20(3).png)
![App Screenshot](./task-4/Screenshot%20(4).png)
![App Screenshot](./task-4/Screenshot%20(5).png)
![App Screenshot](./task-4/Screenshot%20(6).png)
![App Screenshot](./task-4/Screenshot%20(7).png)
![App Screenshot](./task-4/Screenshot%20(8).png)
- here i created .sh script file name "file.sh" and put all the commands in this file and excuted it.
![App Screenshot](./task-4/Screenshot%20(10).png)

2. Create snapshot of the VM.
![App Screenshot](./task-4/Screenshot%20(11).png)
![App Screenshot](./task-4/Screenshot%20(12).png)
![App Screenshot](./task-4/Screenshot%20(13).png)
![App Screenshot](./task-4/Screenshot%20(14).png)
- Creating Virtual machince scale set and load balancer for application sacling and load balancing
![App Screenshot](./task-4/Screenshot%20(15).png)
![App Screenshot](./task-4/Screenshot%20(17).png)
![App Screenshot](./task-4/Screenshot%20(18).png)
![App Screenshot](./task-4/Screenshot%20(19).png)
![App Screenshot](./task-4/Screenshot%20(20).png)
![App Screenshot](./task-4/Screenshot%20(21).png)
![App Screenshot](./task-4/Screenshot%20(22).png)
![App Screenshot](./task-4/Screenshot%20(23).png)
![App Screenshot](./task-4/Screenshot%20(24).png)
![App Screenshot](./task-4/Screenshot%20(25).png)
3. Create 2 more VMs `hello` & `world` from the created snapshot.
![App Screenshot](./task-4/Screenshot%20(26).png)
![App Screenshot](./task-4/Screenshot%20(27).png)
![App Screenshot](./task-4/Screenshot%20(28).png)
![App Screenshot](./task-4/Screenshot%20(29).png)
![App Screenshot](./task-4/Screenshot%20(30).png)
![App Screenshot](./task-4/Screenshot%20(31).png)
![App Screenshot](./task-4/Screenshot%20(32).png)
4. Configure Load balancer and Scaling group.
![App Screenshot](./task-4/Screenshot%20(33).png)
![App Screenshot](./task-4/Screenshot%20(34).png)
![App Screenshot](./task-4/Screenshot%20(35).png)
![App Screenshot](./task-4/Screenshot%20(36).png)
![App Screenshot](./task-4/Screenshot%20(37).png)
![App Screenshot](./task-4/Screenshot%20(38).png)
![App Screenshot](./task-4/Screenshot%20(39).png)
![App Screenshot](./task-4/Screenshot%20(40).png)
![App Screenshot](./task-4/Screenshot%20(41).png)
![App Screenshot](./task-4/Screenshot%20(42).png)
![App Screenshot](./task-4/Screenshot%20(44).png)
- After resource deleting resource
![App Screenshot](./task-4/Screenshot%20(45).png)

## Task 5.

### CI/CD Pipeline and GitHub Actions
#### As task-3 is completed and the pipeline of this process on task-5 
This is complete pipeline github Action.
and the secert are saved in the form of variable.

```yaml
name: Deploy to VM

on:
  push:
    branches:
      - master  # or the branch you want to trigger the workflow

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Install sshpass
      run: sudo apt-get update && sudo apt-get install -y sshpass

    - name: Connect to VM and run commands
      run: |
        sshpass -p ${{ secrets.VM_PASSWORD }} ssh -o StrictHostKeyChecking=no ${{ secrets.VM_USERNAME }}@${{ secrets.VM_IP }} << 'EOF'
          echo "Logged into the VM successfully."
          sudo apt update 
          cd /home/satish/app/flask-hello-world
          git pull
          sudo systemctl stop flaskapp.service
          sudo systemctl start flaskapp.service
          sudo systemctl restart nginx
          
        EOF
```
![App Screenshot](./task-5/Screenshot%20(15).png)
![App Screenshot](./task-5/Screenshot%20(17).png)
![App Screenshot](./task-5/Screenshot%20(18).png)
![App Screenshot](./task-5/Screenshot%20(19).png)
![App Screenshot](./task-5/Screenshot%20(20).png)


## Task-6

### Answer the below questions.

1. What are the steps to set up a VNet, Ubuntu VM in Azure, and configure inbound ports for HTTP and HTTPS access, including IP restrictions?

Ans:

I worked on this things but answer is just copy paste from chatgpt

Setting up a VNet, Ubuntu VM in Azure, and configuring inbound ports for HTTP and HTTPS access with IP restrictions involves several steps. Here’s a detailed guide:

### Step 1: Create a Virtual Network (VNet)

      1. **Navigate to the Azure Portal**:
   - Open [Azure Portal](https://portal.azure.com).

2. **Create a VNet**:
   - Go to "Create a resource" > "Networking" > "Virtual Network".
   - Enter the necessary details:
     - **Name**: Give your VNet a name.
     - **Region**: Choose the region where you want to deploy your VNet.
     - **Address Space**: Define the address range (e.g., 10.0.0.0/16).
     - **Subnet**: Add a subnet (e.g., 10.0.1.0/24).

3. **Review and Create**:
   - Review your configuration and click "Create".

### Step 2: Create an Ubuntu Virtual Machine (VM)

1. **Navigate to the Azure Portal**:
   - Open [Azure Portal](https://portal.azure.com).

2. **Create a VM**:
   - Go to "Create a resource" > "Compute" > "Virtual Machine".
   - Enter the necessary details:
     - **Subscription**: Select your subscription.
     - **Resource group**: Create a new resource group or use an existing one.
     - **Name**: Give your VM a name.
     - **Region**: Choose the region (same as VNet region).
     - **Image**: Select "Ubuntu Server".
     - **Size**: Choose the size based on your requirements.

3. **Administrator Account**:
   - Choose authentication type (SSH public key or password).
   - Enter a username and authentication details.

4. **Networking**:
   - Under "Networking", select the VNet and subnet you created earlier.
   - Make sure to assign a public IP if you want the VM to be accessible from the internet.

5. **Review and Create**:
   - Review your configuration and click "Create".

### Step 3: Configure Network Security Group (NSG) for Inbound Ports

1. **Navigate to the NSG**:
   - Go to "Virtual Machines" > Select your VM > "Networking".
   - Click on the Network Security Group (NSG) linked to your VM's network interface.

2. **Add Inbound Security Rules**:
   - Click on "Inbound security rules" > "Add".
   - Create a rule for HTTP (port 80):
     - **Source**: Any or IP Addresses (for specific IP restrictions).
     - **Source IP addresses/CIDR ranges**: Specify IP ranges if restricting access.
     - **Destination**: Any.
     - **Service**: HTTP.
     - **Action**: Allow.
     - **Priority**: Assign a priority (e.g., 100).
     - **Name**: Name your rule (e.g., allow-http).
   - Create a rule for HTTPS (port 443):
     - Repeat the above steps but select HTTPS as the service.

### Step 4: Configure IP Restrictions

1. **Modify Inbound Security Rules for IP Restrictions**:
   - For each rule (HTTP and HTTPS):
     - **Source**: Change to "IP Addresses".
     - **Source IP addresses/CIDR ranges**: Enter the specific IP ranges allowed to access your VM.

2. **Save Rules**:
   - Save the rules after configuring the IP restrictions.

### Step 5: Verify Configuration

   1. **SSH into the VM**:
   - Use the public IP address and your SSH key or password to connect to the VM.

   2. **Install Web Server (Optional)**:
   - For testing, install Apache or Nginx.
     ```sh
     sudo apt update
     sudo apt install apache2 -y   # for Apache
     sudo apt install nginx -y     # for Nginx
     ```

   3. **Access VM via Browser**:
   - Open a web browser and navigate to `http://<public-ip>` or `https://<public-ip>`.
   - Ensure the page loads correctly, verifying that HTTP and HTTPS access are configured.
----
2. How do you configure an Azure storage account, set up an Azure File Share, and mount it on an Ubuntu VM using SSH?

Ans: 

 I worked on this things but answer is just copy paste from chatgpt

Configuring an Azure Storage Account, setting up an Azure File Share, and mounting it on an Ubuntu VM using SSH involves several steps. Here's a detailed guide:

### Step 1: Create an Azure Storage Account

1. **Navigate to the Azure Portal**:
   - Open [Azure Portal](https://portal.azure.com).

2. **Create a Storage Account**:
   - Go to "Create a resource" > "Storage" > "Storage account".
   - Enter the necessary details:
     - **Subscription**: Select your subscription.
     - **Resource group**: Create a new resource group or use an existing one.
     - **Storage account name**: Provide a unique name for your storage account.
     - **Region**: Choose the region.
     - **Performance**: Select "Standard" or "Premium" based on your needs.
     - **Account kind**: Choose "StorageV2 (general-purpose v2)".
     - **Replication**: Select the replication option (e.g., LRS, GRS).

3. **Review and Create**:
   - Review your configuration and click "Create".

### Step 2: Create an Azure File Share

1. **Navigate to the Storage Account**:
   - Once the storage account is created, go to "Storage accounts" > Select your storage account.

2. **Create a File Share**:
   - Under the "File shares" section, click on "File shares" > "Add file share".
   - Enter the necessary details:
     - **Name**: Provide a name for your file share.
     - **Quota**: Set the quota (optional).

3. **Create the File Share**:
   - Click "Create".

### Step 3: Get the Storage Account Key

1. **Access Storage Account Keys**:
   - In the storage account, go to "Access keys" under the "Settings" section.

2. **Copy the Key**:
   - Copy one of the access keys and the storage account name. You will need these to mount the file share.

### Step 4: Mount the Azure File Share on an Ubuntu VM

1. **SSH into the Ubuntu VM**:
   - Use your SSH client to connect to the Ubuntu VM:
     ```sh
     ssh username@public-ip-address
     ```

2. **Install CIFS Utils**:
   - On your VM, install the CIFS utilities:
     ```sh
     sudo apt update
     sudo apt install cifs-utils -y
     ```

3. **Create a Mount Point**:
   - Create a directory where you want to mount the file share:
     ```sh
     sudo mkdir /mnt/yourmountpoint
     ```

4. **Mount the File Share**:
   - Use the following command to mount the Azure File Share:
     ```sh
     sudo mount -t cifs //storageaccountname.file.core.windows.net/filesharename /mnt/yourmountpoint -o vers=3.0,username=storageaccountname,password=storageaccountkey,dir_mode=0777,file_mode=0777,serverino
     ```
   - Replace `storageaccountname`, `filesharename`, `yourmountpoint`, and `storageaccountkey` with your actual storage account name, file share name, mount point, and access key, respectively.

5. **Verify the Mount**:
   - Check if the file share is mounted successfully:
     ```sh
     df -h
     ```

6. **Persist the Mount (Optional)**:
   - To make the mount persistent across reboots, add an entry to `/etc/fstab`:
     ```sh
     sudo nano /etc/fstab
     ```
   - Add the following line to the file:
     ```sh
     //storageaccountname.file.core.windows.net/filesharename /mnt/yourmountpoint cifs vers=3.0,username=storageaccountname,password=storageaccountkey,dir_mode=0777,file_mode=0777,serverino 0 0
     ```
   - Save and exit the editor (Ctrl+X, then Y, then Enter).
-----
3. Explain the process of using Terraform to automate the setup of Azure resources. What are the benefits and key considerations?

Ans:

On production i never used terraform and But i learn it and have basic understanding of it, like:
- Install Terraform,  Set Up Your Terraform Configuration Files, Create the Main Configuration File, Initialize Terraform, Apply the Configuration.
### Benefits of Using Terraform
- Infrastructure as Code (IaC):

- Consistency and Repeatability:

- Automation:

- Scalability:

- Provider-Agnostic:

- State Management:
-----

4. Describe how to create a GitHub workflow to automate deployment from GitHub to an Azure VM. What are the key considerations to ensure it functions correctly and securely?
 
 - NO Answer

5. What strategies would you implement to secure the entire deployment process, including the VM, storage, and CI/CD pipeline?

- No Answer