#!/bin/bash
sudo apt-get update -y &&

# Prepare TLS encryption
sudo apt-get -y install \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common &&

# Add and verify official Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

# Add apt repo
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable" &&

sudo apt-get update -y &&

# Install Docker CE
sudo apt-get -y install docker-ce docker-ce.cli containerd.io &&

sudo usermod -aG docker ubuntu
