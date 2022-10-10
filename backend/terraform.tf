terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }
  backend "s3" {
    key               = "backend/terraform.tfstate"
    bucket            = "ethos-statefile"
    encrypt           = true
    profile           = "ethos"
    region            = "ap-south-1"
    dynamodb_endpoint = "dynamodb.ap-south-1.amazonaws.com"
    dynamodb_table    = "ethos-pixelstreaming"

  }
  #backend "s3" {
  #  key               = "s3/terraform.tfstate"
  #  bucket="centrae-tf-non-prod"
  #  encrypt           = true
  #  profile           = "signiance-default"
  #  region            = "us-west-2"
  #  dynamodb_endpoint = "dynamodb.us-west-2.amazonaws.com"
  #  dynamodb_table    = "signiance-test"

  #}
}

provider "aws" {
  region = "ap-south-1"

  profile = "ethos"
}
