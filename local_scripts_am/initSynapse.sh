siteName=$1
managerialAccount=$USER
sudo apt -y update
sudo apt-get -y install build-essential python3-dev libffi-dev \
                     python-pip python-setuptools sqlite3 \
                     libssl-dev python-virtualenv libjpeg-dev libxslt1-dev

mkdir -p ~/synapse
cd ~/synapse
virtualenv -p python3 ~/synapse/env
source ~/synapse/env/bin/activate
pip install --upgrade pip
pip install --upgrade setuptools
pip install matrix-synapse
python -m synapse.app.homeserver \
    -H "$siteName" \
    --config-path /home/"$managerialAccount"/synapse/homeserver.yaml \
    --generate-config \
    --report-stats=no
