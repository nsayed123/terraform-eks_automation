# Terraform Module: Kubernetes Platform with Managed PostgreSQL with Superset application deployment

This Terraform module sets up a complete Kubernetes-based application platform on **AWS**, including:

- ✅ **Amazon EKS** (Kubernetes)
- ✅ **Amazon RDS for PostgreSQL**
- ✅ **NGINX ingress controllers** (public & private)
- ✅ **Let's Encrypt TLS certificates via cert-manager**
- ✅ **DNS records in Route53**
- ✅ **Superset Application**

---

## 🚀 Features

- **EKS Cluster** with optional node groups and IAM configuration
- **Managed PostgreSQL** via Amazon RDS
- **NGINX Ingress Controllers**:
  - Public ingress for internet-facing traffic
  - Private ingress for internal services
- **TLS Certificates** from Let's Encrypt using `cert-manager`
- **DNS Automation** using AWS Route53
- **Superset Application** using Terraform Helm

---

## 🧱 Prerequisites

Before using this module, ensure the following are in place:
- Terraform
- aws cli
- git (only to clone this repository)

## Installation

The commands below set everything up to run the Kubernetes Platform with Managed PostgreSQL:
```
$ git clone https://github.com/nsayed123/terraform-eks_automation.git

cd terraform-eks_automation

it has 3 folder
1. modules
2. networking
3. infrastructure

```

## NOTE:
1. We will run networking and infrastructure(eks and rds) separately because our EKS will be setup private.
2. Create S3 bucket to save terraform state files and dynamodb for lock.
3. Before running the terraform init change the profile and region in the provider.tf file.
4. Create an aws credentials profile.
```
aws configure --profile <profilename>
```
5. Update the profile name in the provider.tf.
6. Change the required values in terraform.tfvars
7. ingress and cert_manager is included in one single module ingress
8. When you run terraform infrastructure  it will also deploy superset application
9. There is one caveat. The infrastructure part will take more than 15 mins and the token of the eks will be for 15 mins and it get expired, will get error unauthorized. So please rerun the terraform apply. and it will fix the issue.


## Run
### Networking
#### Steps
1. Create S3 bucket to save terraform state file and dynamodb for lock.
2. Create ssh key in AWS i.e Key pairs.
3. ``` cd terraform-eks_automation/networking ```
4. Configure the backend in backend.tf accordingly.
5. Change the values under tfvars/terraform.tfvars files based on your requirements.
    NOTE: you can name this file whatever makes sense. ex: based on environments
6. 
```
terraform init
terraform plan -var-file=tfvars/terraform.tfvars
terraform apply -var-file=tfvars/terraform.tfvars

If everything looks good type `yes` and hit `Enter` 
```
This will set the base Networking for you. It will output the Public IP of the bastion. This machine is public but will be available from your local has it has restriction in security group. <br />


### infrastructure
ssh into the bastion machine using the public IP from Networking output.

```
ssh -i <ap-south-1.pem> ec2-user@<bastion_public_ip>
```
#### Steps
1. Create S3 bucket to save terraform state file and dynamodb for lock
2. Once logged into bastion
3. ``` git clone https://github.com/nsayed123/terraform-eks_automation.git ```
4. ``` cd terraform-eks_automation/infrastructure ```
5. Configure the backend in backend.tf accordingly.
6. Change the values under tfvars/terraform.tfvars files based on your requirements
    NOTE: you can name this file whatever makes sense. ex: based on environments <br />
*** Important ***
> These keys in the tfvars are important here these gets the subnet values from previous networking output state file. Please set these accordingly. Values of these are the backend details of networking infra.
>> network_tfstate_bucket <br />
>> network_tfstate_key <br />
>> network_tfstate_region <br />
>> network_tfstate_profile <br />
7. 
```
terraform init
terraform plan -var-file=tfvars/terraform.tfvars
terraform apply -var-file=tfvars/terraform.tfvars

If everything looks good type `yes` and hit `Enter` 
```
8. Once the terraform apply is completed run the below command in the bastion machine
```
aws eks update-kubeconfig --region <region> --name <your_cluster_mame>

```

Verify if all the superset pods are running using below command
```
kubectl get po -A
```

Once Verified. Go to browser and hit the dns endpoint of superset application.


## Destroy
If you want to destroy run in bation as well as on local to destroy both networking and infrastructure
```
terraform destroy -var-file=tfvars/terraform.tfvars
```
type `yes` and hit `Enter` 


