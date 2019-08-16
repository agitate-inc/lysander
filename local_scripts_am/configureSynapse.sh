managerialAccount=$USER
registrationBoolean=$1

sed -i "741s/.*/enable_registration : "$registrationBoolean"/" /home/"$managerialAccount"/synapse/homeserver.yaml
cd ~/synapse
source env/bin/activate
synctl stop
synctl start
deactivate
