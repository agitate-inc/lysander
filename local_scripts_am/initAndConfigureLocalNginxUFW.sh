sudo apt -y install nginx
sudo apt -y install ufw
cp ~/lysander/resources/local.nginx.conf /etc/nginx/nginx.conf
ufw allow 'Nginx HTTPS'
ufw allow 'ssh'
yes | ufw reload
sudo service nginx restart
