terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }
}

# Configure the AWS provider
provider "aws" {
  region                   = "eu-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}


 