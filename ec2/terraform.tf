terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }
  backend "s3" {
    key               = "ec2/terraform.tfstate"
    bucket            = "ethos-statefile"
    encrypt           = true
    profile           = "ethos"
    region            = "ap-south-1"
    dynamodb_endpoint = "dynamodb.ap-south-1.amazonaws.com"
    dynamodb_table    = "ethos-pixelstreaming"

  }
}

provider "aws" {
  region = "ap-south-1"

  profile = "ethos"
}
