#!/bin/bash

terraforminstall(){
 if ! command -v terraform &> /dev/null
          then
            echo "Terraform not found. Installing Terraform..."
            sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt-get update && sudo apt-get install terraform -y
          else
            echo "Terraform is already installed"
          fi
}


dockerinstall(){
 if ! command -v docker &> /dev/null
          then
            echo "Docker not found. Installing Docker..."
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo \
              "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io
          else
            echo "Docker is already installed"
          fi
}


awsinstall(){
   if ! command -v aws &> /dev/null
          then
            echo "AWS CLI not found. Installing AWS CLI..."
            sudo apt install unzip -y
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
          else
            echo "AWS CLI is already installed"
          fi  
}


kubectlinstall(){

          if ! command -v kubectl &> /dev/null; then
            echo "kubectl not found. Installing..."
            curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin
          else
            echo "kubectl is already installed: $(kubectl version --short --client)"
          fi
}


eksctlinstall(){
 echo "#######   eksctl    ######"
         if ! command -v eksctl &> /dev/null; then
         echo "eksctl not found. Installing..."
         curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
         sudo mv /tmp/eksctl /usr/local/bin
         else
         echo "eksctl is already installed: $(eksctl version)"
         fi    

}

helm(){
 echo "#######   Checking Helm   ######"
          if ! command -v helm &> /dev/null; then
            echo "Helm not found. Installing..."
             curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
             chmod 700 get_helm.sh
             ./get_helm.sh
          else
            echo "Helm already installed: $(helm version --short)"
          fi

  echo "#######   Helm repo check   ######"
          if helm repo list | grep -q '^eks'; then
            echo "EKS Helm repo already exists"
          else
            echo "Adding EKS Helm repo"
            helm repo add eks https://aws.github.io/eks-charts
          fi
          helm repo update
}

terraforminstall
dockerinstall
awsinstall
kubectlinstall
eksctlinstall
#helm


