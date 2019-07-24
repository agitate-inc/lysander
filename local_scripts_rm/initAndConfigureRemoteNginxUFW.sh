remoteIP=$1
siteName=$2
##The remote.nginx_x.conf files must be prepared before this script is launched.

scp -i ~/.ssh/rmroot_rsa ~/lysander/resources/scp_scripts/installNginxAndSetupUFW.scp root@"$remoteIP":/root/installNginxAndSetupUFW.sh;
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "bash ~/installNginxAndSetupUFW.sh";
scp -i ~/.ssh/rmroot_rsa ~/lysander/resources/remote.nginx_precert.scp root@"$remoteIP":/etc/nginx/nginx.conf;
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "yes | service nginx restart";
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "sudo certbot certonly -d "$siteName" -q --nginx --keep-until-expiring --register-unsafely-without-email --agree-tos"
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "sudo certbot certonly -d "$siteName" -q --nginx --keep-until-expiring --register-unsafely-without-email --agree-tos"
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "groupadd -g 1024 letsencrypt"
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "chgrp -R letsencrypt /etc/letsencrypt; chmod -R g=rX /etc/letsencrypt"
scp -i ~/.ssh/rmroot_rsa ~/lysander/resources/remote.nginx_postcert.scp root@"$remoteIP":/etc/nginx/nginx.conf;
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "yes | service nginx restart";
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "sudo certbot certonly -d flawlesscougarbuffet.tk -q --nginx --keep-until-expiring --register-unsafely-without-email --agree-tos"
