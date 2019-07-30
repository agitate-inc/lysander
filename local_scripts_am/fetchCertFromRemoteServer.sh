remoteIP=$1
siteName=$2
managerialAccount=$USER

sudo mkdir /etc/amok;
sudo chmod 755 /etc/amok;
sudo chown "$managerialAccount":"$managerialAccount" /etc/amok

scp -i ~/.ssh/rmmanager_rsa manager@"$remoteIP":/etc/letsencrypt/live/"$siteName"/fullchain.pem /etc/amok/fullchain.pem;
scp -i ~/.ssh/rmmanager_rsa manager@"$remoteIP":/etc/letsencrypt/live/"$siteName"/privkey.pem /etc/amok/privkey.pem;

chmod -R 755 /etc/amok;
