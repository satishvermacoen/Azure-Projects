$ mkdir flask-2
$ cd flask-2
$ ls
$ python3 -m venv menv
$ source ./menv/bin/activate
$ git clone https://github.com/satishvermacoen/flask-hello-world.git
app.py has line misssing 

$ pip3 install flask gunicorn
$ python3 flask-2/flask-hello-world/app.py
Create WSGi Entry Point
$
--------------
sudo apt install python3-pip
sudo apt install python3.12-venv

source ./menv/bin/activate

pip3 install flask gunicorn

gunicorn -w 4 --bind 0.0.0.0:8000 wsgi:app

sudo su

sudo cat >>/etc/systemd/system/my-server.service

[Unit]
Description=Flask Web Application Server using Gunicorn
After=network.target

[Service]
User=satish
Group=www-data
WorkingDirectory=/home/satish/flask-hello-world
Environment="PATH=/home/satish/flask-hello-world/menv/bin"
ExecStart=/bin/bash -c 'source /home/satish/flask-hello-world/menv/bin/activate; gunicorn -w 3 --bind unix:/tmp/my-server/ipc.sock wsgi:app'
Restart=always

[Install]
WantedBy=multi-user.target





sudo apt install supervisor




[supervisord]
nodaemon=true
pidfile = /tmp/supervisord.pid
logfile = /tmp/supervisord.log
logfile_maxbytes = 10MB
logfile_backups=10
loglevel = debug

[unix_http_server]
file = /tmp/supervisor.sock

[supervisorctl]
serverurl = unix:///tmp/supervisord.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[include]
files = /etc/supervisord.d/*.conf




mkdir /etc/supervisord.d/

sudo cat >>/etc/supervisord.d/gunicorn.conf

[program:flask_catalog] 
command=/bin/bash -c 'source /home/satish/flask-hello-world/menv/bin/activate; gunicorn -w 3 --bind unix:/tmp/my-server/ipc.sock wsgi:app'
directory=/home/deepak/flask-hello-world
user=satish
group=www-data
autostart=true 
autorestart=true 
stdout_logfile=/tmp/app.log 
stderr_logfile=/tmp/error.log

sudo apt install nginx

sudo su

cat >>sites-available/my-server

server {
    listen 80;

    location / {
        include proxy_params;
        proxy_pass http://unix:/tmp/my-server/ipc.sock;
    }
}

sudo ln -s /etc/nginx/sites-available/my-server /etc/nginx/sites-enabled/

