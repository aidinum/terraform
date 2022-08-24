# Project: EKS Cluster using terraform

Terraform modules which create AWS EKS (Kubernetes) and VPC resources for dev/prod environments.

## Prerequisites:
configured AWS CLI

IAM authenticator -- for kubeconfig

install kubectl

## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

```bash
terraform init   //to initialize terraform 
terraform plan -var-file=./dev/dev.tfvars  //to review the tf scripts and to make the plan by terraform
terraform apply -var-file=./dev/dev.tfvars //final command to execute the provision of infrastructure


```


## Run these commands to copy the EKS configuration to kubectl cli tool in order to connect with k8s

```python
aws eks --region us-east-1 update-kubeconfig --name dev_eks_cluster --profile YOUR_PROFILE

# Run these commands to create yaml file for the aws-auth config map and deploy it:

terraform output config-map-aws-auth > config-map-aws-auth.yaml
  
kubectl apply -f config-map-aws-auth.yaml 
 
# check nodes:
kubectl get nodes
```

## To Install Nginx Ingress-Controller Run Makefile:
```
# install nginx
make
# run test
make
# delete test resources
make
```

Please make sure to update tests as appropriate.

## Github
Github:
Add"./terraform" folder to ".gitignore" to skip it when pushing to GitHub.

## Additional resources:
More on troubleshooting EKS clusters:
https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html

## Project Issues:
1. issue: e_ip and nat dependency. make sure u create eip first
2. EntityAlreadyExists: Instance Profile eks-instance-profile1 already exists. 

solution:
added:
lifecycle {
    create_before_destroy = true # or false
  }

3. ISSUE:
problem creating multi-az instances

solution: changed vpc_zone_identifier = local.public_subnet_ids instead of identifying azs

## What can be Improved?
- separate reusable modules
- kms encryption of cluster
- kms encryption of s3 bucket
- NAT gateway for each AZ for HA
- cloudwatch, health in elb
- vpc flow logs
- data source sensitive data from parameter store or secrets manager
add config audit on k8s

## ADD-ON:
If you wish to add cluster-autoscaler -- necessary IAM roles and node tags have been added.
Also contains resources enabling IAM Roles for Service Accounts