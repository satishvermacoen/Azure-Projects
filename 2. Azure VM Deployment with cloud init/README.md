# 2. Azure VM Deployment with cloud init.
In this Project, a Deployment of Azure and configure as wedserver and ready to with live website(My Resume) hosted on Azure VM. All this deployment with automate with one script and cloud init.txt. After pointing it to the domain name with the use of Azure DNS.

## Azure Resource Created

1. Azure Virtual Network 
2. Azure Vitual Machine
3. Azure DNS
4. Domain name(satishvermacloudlearning.shop)

![Overview](https://github.com/satishvermacoen/Azure-LAB/blob/main/aws-azure-vpn-connectivity/img/draw.png)

## Process
### Cloud init.txt

1. Create and save the the cloud init.txt for post package install and deployment configuration.

```bash
  #cloud-config
package_upgrade: true
packages:
  - nginx
  - nodejs
  - npm
write_files:
  - owner: www-data:www-data
    path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80;
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/mycert.cert;
        ssl_certificate_key /etc/nginx/ssl/mycert.prv;
        location / {
          proxy_pass http://localhost:3000;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection keep-alive;
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
      }
  - owner: azureuser:azureuser
    path: /home/azureuser/myapp/index.js
    content: |
      var express = require('express')
      var app = express()
      var os = require('os');
      app.get('/', function (req, res) {
        res.send('Hello World from host ' + os.hostname() + '!')
      })
      app.listen(3000, function () {
        console.log('Hello world app listening on port 3000!')
      })
runcmd:
  - secretsname=$(find /var/lib/waagent/ -name "*.prv" | cut -c -57)
  - mkdir /etc/nginx/ssl
  - cp $secretsname.crt /etc/nginx/ssl/mycert.cert
  - cp $secretsname.prv /etc/nginx/ssl/mycert.prv
  - service nginx restart
  - cd "/home/azureuser/myapp"
  - npm init
  - npm install express -y
  - nodejs index.js

```





2. Create a stoarge account and with basic detail as required to create.
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(79).png)
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(80).png)

3. Enabled static website option in storage account.
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(81).png)

4. Upload website contain in $web container. Config index.html file with Static website in index document name.

![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(82).png)

5. login to godaddy.com.

![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(83).png)

6. Config the wesite forwarding mask on domain name.

![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(84).png)

7. Website is live.
![App Screenshot](https://github.com/satishvermacoen/Azure-Projects/blob/main/1.%20Static%20WebSite%20deployment%20and%20hosting%20on%20Azure%20Blob%20Storage/img/Screenshot%20(85).png)

8. Create a site-to-site VPN Connection

9. Download the configuration file

10. Now let’s create the Local Network Gateway
