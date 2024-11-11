# Installing LAMP stack on Ubuntu 20.04

This will explain how to install LAMP stack on Ubuntu 20.04. LAMP stack consists of the following components:

Linux - Any Linux based operating system
Apache server - Apache is an open-source webserver
MySQL - MySQL database
PHP - PHP as a server-side programming language
These components work together to host single or multiple dynamic websites that are stable in production.
## To update the OS
```
sudo apt update
```

## Installing Apache and allowing it through the firewall

Apache is an amazing open-source web server. Let's install it using the following commands:
```
sudo apt install apache2 -y
```
![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(31).png)

IF - FIREWALL-CONFIG
that ALLOW
```
sudo ufw allow in "Apache Full"

```
>This command allow Apache through the firewall.

>You can always issue the "sudo ufw status" command to verify the changes:
```
sudo ufw status
```
Congratulations! You have successfully installed the apache web server on your server

## Installing MySQL on Ubuntu
MySQL is a very popular and open source database that can be used with almost any application to store huge amounts of data effectively.

Command to install MySQL on ubuntu:
```
sudo apt install mysql-server
```

![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(32).png)

You should be able to login to MySQL console by typing the following command:


sudo mysql


To exit the MySQL console type exit in the MySQL console

exit

## Installing PHP

We can install PHP by firing the following commands:

```
sudo apt install php libapache2-mod-php php-mysql
```

This will install the following 3 packages

* php -  installs PHP
* libapache2-mod-php - Used by apache to handle PHP files
* php-mysql - PHP module that allows PHP to connect to MySQL 

Confirm the PHP installation by executing the below command:
```
php -v
```
![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(37).png)
Congratulations! You have successfully installed LAMP stack on your server.