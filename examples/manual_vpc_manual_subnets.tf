module "vpc" {
  source     = "github.com/sgc-main/terraform-aws-vpc"

  region             = var.region
  vpc-cidrs          = var.vpc-cidrs
  name-vars          = var.name-vars
  subnets            = var.subnets
  zones              = var.zones
  tags               = var.tags
}

variable "region" {
  default = "us-east-1"
}
 
variable "vpc-cidrs" {
  default = ["10.0.0.0/21"]
}

variable "name-vars" {
  default = {
    account = "geek37"
    name    = "dev"
  }
}

variable "subnets" {
  default = {
    pub = "10.0.0.0/24"
    web = "10.0.1.0/24"
    app = "10.0.2.0/24"
    db  = "10.0.3.0/24"
    mgt = "10.0.4.0/24"
  }
}

variable "zones" {
  default = {
    us-east-1 = ["us-east-1a","us-east-1b"]
  }
}

variable tags {
  type = map
  default = {
    Environment = "prd"
    Module      = "inf"
  }
}
