remoteFingerprintTrusted=$1
remoteIP=$2
remoteRootPassword=$3
amokTarget=$4
siteName=$5

bash local_scripts_rm/secureRemoteRoot.sh $remoteFingerprintTrusted $remoteIP $remoteRootPassword;
bash local_scripts_rm/configureNginxScp.sh $amokTarget $siteName;
bash local_scripts_rm/initAndConfigureRemoteNginxUFW.sh $remoteIP $siteName;
bash local_scripts_rm/makeAndSecureRemoteManager.sh $remoteIP;

bash local_scripts_am/fetchCertFromRemoteServer.sh $remoteIP $siteName;
bash local_scripts_am/initAndConfigureLocalNginxUFW.sh;
bash local_scripts_am/initSynapse.sh $siteName;
