managerialAccount=$USER
registrationBoolean=$1

sed -i "741s/.*/enable_registration : "$registrationBoolean"/" /home/"$managerialAccount"/homeserver.yaml
source ~/synapse/env/bin/activate
synctl restart
deactivate
