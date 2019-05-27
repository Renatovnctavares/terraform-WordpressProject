#!/bin/bash
mkdir /tmp/teste
sudo yum -y update
sudo yum install -y docker
sudo yum install -y git
sudo service docker start
sudo mv /tmp/docker.service /lib/systemd/system/
export DOCKER_HOST=localhost:2376
echo "export DOCKER_HOST=localhost:2376" >> /home/ec2-user/.bash_profile
sudo systemctl daemon-reload
sudo service docker restart
docker pull wordpress
docker run -p 8080:80 -e $1 -e $2 -e $3 -e $4 -d wordpress
