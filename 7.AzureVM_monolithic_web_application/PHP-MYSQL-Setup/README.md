# Installing phpMyAdmin and adding password authentication to MySQL on Ubuntu
In this, we see how to install and secure phpMyAdmin on Ubuntu 20.04. phpMyAdmin was created to easily interact with MySQL databases using a web-based interface.

We will also see how to enable password authentication on MySQL which supports socket-based authentication by default.

## Step 1 - Installing PHPMyAdmin 

Run the following command to install phpMyAdmin and related packages
```
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
```
![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(38).png)

Using this command we installed the following packages:

* php-mbstring: A module for managing non-ASCII strings with different encodings
* php-zip: An extension that facilitates uploading .zip files to phpMyAdmin
* php-gd: Enables support for GD graphics library
* php-json: Provides support for JSON serialization
* php-curl: Allows PHP to communicate with other servers

## Step 2 - Configuring password access in MySQL
 To use MySQL we need to enable password login in MySQL. enter the following command to launch the MySQL console:
 ```
 sudo mysql
 ```
 Now enter the following query to enable password authentication in MySQL
```
 ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'MyStrongPassword1234$';
```
Please make sure you choose your own password and not the one which I chose ('MyStrongPassword1234$')

You can always check the authentication method used by using the following MySQL query:
```
SELECT user,authentication_string,plugin,host FROM mysql.user;
```

Exit from the MySQL console by typing exit.

![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(44).png)

Now you can log in using your MySQL password by entering the following command to the MySQL console

```
sudo mysql -u root -p
```
![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(46).png)
## Step 3 - Configuring a non-root user in MySQL

Since its not a good idea to use root as your login user, we will create another MySQL user named satish to login to the PHPMyAdmin console:

Execute the following query:
```
CREATE USER 'satish'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'MyStrongPassword1234$';
```
This creates a user named satish with the password - 'MyStrongPassword1234$'

Let's provide this user all the privileges so that we can use it to access the PHPMyAdmin console. Execute the query below
```
GRANT ALL PRIVILEGES ON *.* TO 'harry'@'localhost' WITH GRANT OPTION;
```
You can now exit the MySQL shell:
```
exit 
```
or

CRTL+D

## Step 4 - Accessing phpMyAdmin 

Go to the browser and type 'http://your_domain_or_IP/phpmyadmin' in your URL bar. You will see an option to log into your PHPMyAdmin console. Enter the username (satish in my case) and password you chose for this user.

You will be logged in to PHPMyAdmin.


![App Screenshot](https://github.com/satishvermacoen/Linux-Server-Depoly/blob/main/img/Screenshot%20(48).png)



> Enjoy managing your MySQL databases with ease and security. Happy coding!
