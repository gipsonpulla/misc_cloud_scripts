terraform {
    backend "s3" {
        bucket = "gips-my-bucket"
        dynamodb_table = "terraform-state-lock"
        key = "global/mysate/my-state-file/terraform.state"
        region = "us-east-1"
        encrypt = true
    }
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "6.12.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}
