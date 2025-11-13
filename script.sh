#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required dependencies
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker (official method)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Grant permission for the 'ubuntu' user to run Docker without sudo (optional but recommended)
sudo usermod -aG docker ubuntu

# Enable and start the Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Wait a few seconds to ensure the service is fully up and running
sleep 10
