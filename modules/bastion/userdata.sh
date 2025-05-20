#!/bin/bash
set -e

# Install dependencies
sudo yum update -y
sudo yum install -y unzip bash-completion vim  
sudo yum install -y curl --allowerasing
# Install kubectl
sudo curl -o /usr/local/bin/kubectl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.3/2025-04-17/bin/linux/amd64/kubectl"
sudo chmod +x /usr/local/bin/kubectl

# Enable kubectl bash completion
echo "source <(kubectl completion bash)" | sudo tee -a /etc/bashrc
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform