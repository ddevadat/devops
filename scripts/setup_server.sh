#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo  "Installating PIP"
apt-get install -y python3-pip

echo  "Installating Ansible"
pip3 install ansible

echo  "Installating jq"
apt-get install -y jq