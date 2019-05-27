## Description
Simple deployment and configuration project

## What does it contain?
- git flow
- App: NodeJS simple server
- App: NodeJS added routing and static files
- App: Added Dockerfile
- App: Hardening script for dockerfile
- App: Hardening Dockerfile
- Terraform: Remote state file on s3 storage
- Terraform: Lock on state file based on DynamoDB
- Terraform: Create networking
- Terraform: Creating NSG
- Terraform: Creating 2 VMs
- Terraform: Create LoadBalancer

## Requirements:
- Terraform user in AWS with proper policy
- S3 storage for Terraform state file

## Build docker image:
`docker login` <br />
`docker run -d -p 3000:3000 --name hwapp -v $(pwd)/logs/:/usr/src/app/logs/  helloworldapp` <br />
`docker push`

## Terraform
1. Create terraform variable `*.auto.tfvars` file with: `secret_key`, `access_key`, f.e.: <br />
```
secret_key = "foo"
access_key = "bar"
public_ssh_key = "ssh-rsa foobar foo@bar"
```
I know I could use vault, but this way it is a lot easier for this example.
2. Create manually s3 bucket for state file (f.e. `terraform-remote-state-storage-s3-j67698`), change its name in `backend_state_storage.tf` and `main.tf`
3. Create DynamoDB table named `terraform_state` with primary key `LockID`
4. Import resources <br />
```
terraform import aws_s3_bucket.terraform-remote-state-storage-s3-j67698 terraform-remote-state-storage-s3-j67698
terraform import aws_dynamodb_table.terraform_state terraform_state
```
5. Do `terraform init` <br />
6. Do `terraform plan` <br />
7. Do `terraform apply`

## Ansible
