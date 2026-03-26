#!/bin/bash

ARCH=$(arch)

### installing Docker
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install nfs-kernel-server vim htop docker-ce docker-ce-cli containerd.io docker-compose-plugin -y


### Installing Kube tools and Helm.
if [ $ARCH = "x86_64" ]
then
	echo executing on $ARC
	
	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
	
	sudo apt-get install curl gpg apt-transport-https --yes
        curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
        sudo apt-get update
        sudo apt-get install helm

fi

if [ $ARCH = "aarch64" ]
then
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
	sudo install minikube-linux-arm64 /usr/local/bin/minikube
	sudo snap install kubectl --classic	
fi

echo the script is now complete.

sudo usermod -aG docker $USER
newgrp docker