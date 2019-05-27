terraform {
  required_version = "~> 0.10"

  backend "s3" {
   encrypt = true
   bucket = "terraform-remote-state-storage-s3-j67698"
   region = "eu-central-1"
   key = "dev/terraform.tfstate"
   dynamodb_table = "terraform_state"
  }

}
