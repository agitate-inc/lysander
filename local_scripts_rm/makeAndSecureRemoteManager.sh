##TESTING : REMOTE ROOT NOT CLOSED

remoteIP=$1

scp -i ~/.ssh/rmroot_rsa ~/lysander/resources/scp_scripts/makeManager.scp root@"$remoteIP":/root/makeManager.sh;
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "bash ~/makeManager.sh";

ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "mkdir -p /home/manager/.ssh; touch /home/manager/.ssh/authorized_keys; \
chown -R manager:manager /home/manager; chmod 755 /home/manager ; chmod 700 /home/manager/.ssh ; chmod 600 /home/manager/.ssh/authorized_keys";

yes | ssh-keygen -t rsa -f ~/.ssh/rmmanager_rsa -N '';
scp -i ~/.ssh/rmroot_rsa ~/.ssh/rmmanager_rsa.pub root@"$remoteIP":/root/rmmanager_rsa.pub;

ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "cat ~/rmmanager_rsa.pub >> /home/manager/.ssh/authorized_keys";

## ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "sed -i '32s/.*/PermitRootLogin no/' /etc/ssh/sshd_config; service sshd restart";
