#!/bin/bash
sudo apt -y install sshpass
mkdir -p ~/.ssh
touch ~/.ssh/known_hosts
touch ~/.ssh/remoteRootPassword.txt

remoteFingerprintTrusted=$1
remoteIP=$2
remoteRootPassword=$3
remoteKeyUntrusted="$(ssh-keyscan $remoteIP -t rsa 2>/dev/null)"
remoteFingerprintUntrusted="$(echo $remoteKeyUntrusted | ssh-keygen -lf - | awk '{print $2}')"

 echo "$remoteRootPassword" >> ~/.ssh/remoteRootPassword.txt;
#Note : The remote server must have one and only one RSA fingerprint. Otherwise the fingerprint-verification op will fail.

#If the fingerprint of the retrieved remote key is equal to the fingerprint provided by the user, then add to known hosts.
#Otherwise, exit 1.
if [ "$remoteFingerprintTrusted" != "$remoteFingerprintUntrusted" ]
  then
    exit 1
  fi
remoteKeyTrusted="$remoteKeyUntrusted"
echo "$remoteKeyTrusted" >> ~/.ssh/known_hosts

ssh-keygen -t rsa -f ~/.ssh/rmroot_rsa -N ''
sshpass -f ~/.ssh/remoteRootPassword.txt ssh-copy-id -i ~/.ssh/rmroot_rsa.pub root@"$remoteIP"
ssh -i ~/.ssh/rmroot_rsa root@"$remoteIP" "sed -i '61s/.*/ChallengeResponseAuthentication no/' \
/etc/ssh/sshd_config; sed -i '56s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config; \
service sshd restart"
