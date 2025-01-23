data "aws_region" "current" {}

data "aws_vpc_ipam_pool" "vpc" {
  filter {
    name   = "address-family"
    values = ["ipv4"]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.current.name]
  }

}

module "vpc" {
  source     = "github.com/sgc-main/terraform-aws-vpc"

  region                           = data.aws_region.current.name
  ipam_netmask_length              = var.ipam_netmask_length
  ipv4_ipam_pool_id                = data.aws_vpc_ipam_pool.vpc.id
  name-vars                        = var.name-vars
  fixed-subnets-only               = var.fixed-subnets-only
  dynamic-subnet-symentric-newbits = var.dynamic-subnet-symentric-newbits
  zones                            = var.zones
  tags                             = var.tags
}

variable ipam_netmask_length {
  default = 21
}

variable name-vars {
  default = {
    account = "tst"
    name    = "dev"
  }
}

variable fixed-subnets-only {
    default = true
}

variable dynamic-subnet-symentric-newbits {
    default = false
}

variable zones {
  default = {
    us-east-1 = ["us-east-1a","us-east-1b","us-east-1c"]
  }
}

variable tags {
  type = map
  default = {
    Environment = "dev"
    Module      = "inf"
  }
}