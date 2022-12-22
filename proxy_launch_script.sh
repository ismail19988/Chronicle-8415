#!/bin/bash

cd ~;
apt update;
apt install git -y;
apt -y install python3-pip;
pip3 install flask;
pip3 install pythonping;

git clone https://github.com/ismail19988/files.git;

cd files;
chmod 600 proxy.pem;
python3 ssh_server.py;




