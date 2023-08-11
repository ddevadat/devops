#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

#Install openjdk
echo -e "\n\e[0;32m${bold}Installating openjdk 11${normal}"
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar -xf openjdk-11+28_linux-x64_bin.tar.gz
mv jdk-11 java-11-openjdk-amd64
cp -r java-11-openjdk-amd64 /usr/lib/jvm/
rm -rf java-11-openjdk-amd64 openjdk-11+28_linux-x64_bin.tar.gz

echo -e "\n\e[0;32m${bold}Installating Jenkins${normal}"
sudo apt update
sudo apt install -y openjdk-11-jre
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins

echo -e "\n\e[0;32m${bold}Installating PIP${normal}"
apt-get install -y python-pip
apt-get install -y python3-pip


echo -e "\n\e[0;32m${bold}Installating Maven${normal}"
apt-get install -y maven

echo -e "\n\e[0;32m${bold}Installating Git ${normal}"
apt-get install -y git

echo -e "\n\e[0;32m${bold}Installating zip unzip${normal}"
apt-get install -y unzip zip

echo -e "\n\e[0;32m${bold}Installating JQ${normal}"
apt-get install -y jq

echo -e "\n\e[0;32m${bold}Installating Simplejson${normal}"
apt-get install -y python-simplejson

echo -e "\n\e[0;32m${bold}Installating tree${normal}"
apt install tree -y

echo -e "\n\e[0;32m${bold}Installating Docker${normal}"
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo -e "\n\e[0;32m${bold}Installating node and npm modules"
wget https://nodejs.org/download/release/v6.17.1/node-v6.17.1-linux-x64.tar.gz
tar -xf node-v6.17.1-linux-x64.tar.gz
rm -rf /usr/local/lib/node-v6.17.1-linux-x64
rm -rf /usr/bin/node
rm -rf /usr/bin/npm
rm -rf /usr/bin/grunt
rm -rf /usr/bin/bower
rm -rf /usr/bin/gulp
mv node-v6.17.1-linux-x64 /usr/local/lib/
ln -s /usr/local/lib/node-v6.17.1-linux-x64/bin/node /usr/bin/node
ln -s /usr/local/lib/node-v6.17.1-linux-x64/bin/npm /usr/bin/npm
npm install -g grunt-cli@1.2.0
ln -s /usr/local/lib/node-v6.17.1-linux-x64/bin/grunt /usr/bin/grunt
npm install -g bower@1.8.0
ln -s /usr/local/lib/node-v6.17.1-linux-x64/bin/bower /usr/bin/bower
npm install -g @alexlafroscia/yaml-merge
ln -s /var/lib/jenkins/.nvm/versions/node/v12.16.1/bin/yaml-merge /usr/bin/yaml-merge
npm install -g gulp@3.9.1
ln -s /usr/local/lib/node-v6.17.1-linux-x64/bin/gulp /usr/bin/gulp
rm -rf node-v6.17.1-linux-x64*

echo -e "\n\e[0;32m${bold}Installating Ansible${normal}"
pip uninstall -y ansible
pip3 install ansible

echo -e "\n\e[0;32m${bold}Installing oci cli ${normal}"
oci_cli_setup_zip="https://github.com/oracle/oci-cli/releases/download/v3.22.0/oci-cli-3.22.0-Ubuntu-18.04-Offline.zip"
wget $oci_cli_setup_zip -O /tmp/ocicli.zip
unzip /tmp/ocicli.zip -d /tmp
cd /tmp
./oci-cli-installation/install.sh --install-dir /var/lib/jenkins --exec-dir /var/lib/jenkins --script-dir /var/lib/jenkins --accept-all-defaults

echo -e "\n\e[0;32m${bold}Installating pip docker${normal}"
pip install docker
pip3 install docker

echo -e "\n\e[0;32m${bold}Installating colordiff${normal}"
apt-get install -y colordiff

echo -e "\n\e[0;32m${bold}Adding jenkins user to docker group${normal}"
usermod -aG docker jenkins

echo -e "\n\e[0;32m${bold}Creating bashrc for jenkins user ${normal}"
cp /etc/skel/.bashrc /var/lib/jenkins
chown jenkins:jenkins /var/lib/jenkins/.bashrc

echo -e "\n\e[0;32m${bold}Installing jmespath${normal}"
sudo apt install -y python3-jmespath


# Install Helm version 3.0.2
echo -e "\n\e[0;32m${bold}Installating Helm${normal}"
wget https://get.helm.sh/helm-v3.0.2-linux-386.tar.gz
tar -xzvf helm-v3.0.2-linux-386.tar.gz
rm -rf /usr/local/bin/helm
cp linux-386/helm /usr/local/bin/helm
rm -rf helm-v* linux-amd*

# Install kubectl v1.22.0
echo -e "\n\e[0;32m${bold}Installating kubectl${normal}"
curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin


# Install yarn
echo -e "\n\e[0;32m${bold}Installating yarn${normal}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update && apt install -y yarn


# Install python-psycopg3
echo -e "\n\e[0;32m${bold}Installating python-psycopg2${normal}"
apt install -y python3-psycopg2

# Install libpng-dev - Ubuntu 18 and above fix for plugin builds
echo -e "\n\e[0;32m${bold}Installating libpng-dev${normal}"
apt install -y libpng-dev

echo -e "\n\e[0;32m${bold}Clean up${normal}"
sudo apt -y autoremove


# Install kubectx,kubens
echo -e "\n\e[0;32m${bold}Installating kubectx,kubens${normal}"
wget https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx
chmod 755 kubectx
mv kubectx /usr/local/bin
wget https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens
chmod 755 kubens
mv kubens /usr/local/bin


# Install Istio
echo -e "\n\e[0;32m${bold}Installating Istio${normal}"
mkdir -p /var/lib/jenkins/istio
chown -R jenkins:jenkins /var/lib/jenkins/istio
cd /var/lib/jenkins/istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.2 TARGET_ARCH=x86_64 sh -
chown -R jenkins:jenkins /var/lib/jenkins/istio
cp istio-1.18.2/bin/istioctl /usr/local/bin

