#!/bin/bash
set -e

#update packages and install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-http ca-certificates curl gnupg lsb-release

#add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#add Docker's repository 
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#update package database with Docker packages
sudo apt-get update

#Install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#copy the git repo to /home/ubuntu/app
git clone https://github.com/Grasmit/infrastructure-as-a-code.git /home/ubuntu/app

#change directory to git hub repository
cd /home/ubuntu/flask-app

#Build Docker image
docker build -t password-app

#run the docker container
docker run -d --name app-container -p 80:3000 password-app