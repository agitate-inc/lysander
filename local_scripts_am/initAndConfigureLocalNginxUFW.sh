sudo apt -y update
sudo apt -y install nginx
sudo apt -y install ufw
cp ~/lysander/resources/local.nginx.conf /etc/nginx/nginx.conf
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow 'ssh'
yes | sudo ufw enable
yes | sudo ufw reload
sudo service nginx restart
