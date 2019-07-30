sudo apt -y install nginx
sudo apt -y install ufw
cp ~/lysander/resources/local.nginx.conf /etc/nginx/nginx.conf
yes | ufw allow 'Nginx HTTPS'
sudo service nginx restart
