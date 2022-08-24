provider "aws" {
  region  = "us-east-1"
  profile = "dev"
}
terraform {
  backend "s3" {
    bucket         = "22a-tfstate-eks"
    dynamodb_table = "eks-state-lock"
    region         = "us-east-1"
    key            = "eks/terraform.tfstate"
    encrypt        = true
    profile        = "dev"
  }
}


resource "aws_dynamodb_table" "eks-state-lock" {
  name           = "eks-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20


  attribute {
    name = "LockID"
    type = "S"
  }
}
