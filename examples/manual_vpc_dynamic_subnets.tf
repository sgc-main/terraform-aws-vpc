module "vpc" {
  source                               = "github.com/sgc-main/terraform-aws-vpc"

  region                               = var.region
  zones                                = var.zones
  name-vars                            = var.name-vars
  dynamic-vpc-cidr                     = var.dynamic-vpc-cidr
  dynamic-subnets-names                = var.dynamic-subnets-names
  dynamic-subnet-symentric-newbits     = var.dynamic-subnet-symentric-newbits
  tags                                 = var.tags
}

variable region {
  default = "us-east-1"
}

variable zones {
  default = {
    us-east-1 = ["us-east-1a","us-east-1b"]
  }
}

variable name-vars {
  default = {
    account = "tst"
    name    = "dev"
  }
}

variable dynamic-vpc-cidr {
  default = "10.0.0.0/21"
}

variable dynamic-subnets-names {
  default = ["k8s", "prv", "pub"]
}

variable dynamic-subnet-symentric-newbits {
  default = false
}

variable tags {
  type = map
  default = {
    Environment = "prd"
    Module      = "inf"
  }
}