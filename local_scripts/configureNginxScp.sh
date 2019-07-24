amokTarget=$1
siteName=$2

sed -i "16s/.*/server_name "$siteName";/" ~/lysander/resources/remote.nginx_precert.scp;
sed -i "25s|.*|ssl_certificate /etc/letsencrypt/live/"$siteName"/fullchain.pem;|" ~/lysander/resources/remote.nginx_postcert.scp
sed -i "26s|.*|ssl_certificate_key /etc/letsencrypt/live/"$siteName"/privkey.pem;|" ~/lysander/resources/remote.nginx_postcert.scp
sed -i "32s|.*|proxy_pass https://"$amokTarget";|" ~/lysander/resources/remote.nginx_postcert.scp
sed -i "41s|.*|proxy_pass https://"$amokTarget";|" ~/lysander/resources/remote.nginx_postcert.scp
