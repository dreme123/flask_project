terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

provider "aws" {
  region     = local.region
  access_key = local.acess_key
  secret_key = local.secret_key
}

