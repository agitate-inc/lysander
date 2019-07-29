remoteIP=$1
siteName=$2

mkdir ~/.ssl;

scp -i ~/.ssh/rmmanager_rsa manager@"$remoteIP":/etc/letsencrypt/live/"$siteName"/fullchain.pem /home/anon/.ssl/fullchain.pem;
scp -i ~/.ssh/rmmanager_rsa manager@"$remoteIP":/etc/letsencrypt/live/"$siteName"/privkey.pem /home/anon/.ssl/privkey.pem;
