resource "aws_vpc" "main_vpc" {
  cidr_block           = var.ipv4_ipam_pool_id != null ? data.aws_vpc_ipam_preview_next_cidr.main_cidr["main_vpc"].cidr : var.dynamic-vpc-cidr != null ? var.dynamic-vpc-cidr : var.vpc-cidrs[0]
  ipv4_ipam_pool_id    = var.ipv4_ipam_pool_id != null ? var.ipv4_ipam_pool_id : null
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy
  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s", var.vpc-name == "null" ? "${var.name-vars["account"]}-${replace(var.region, "-", "")}-${var.name-vars["name"]}" : var.vpc-name) }),
    local.resource-tags["aws_vpc"]
  )
  lifecycle {
    ignore_changes = [cidr_block]
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidrs" {
  for_each = { for cidr in var.vpc-cidrs : cidr => cidr
  if cidr != var.vpc-cidrs[0] }
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = each.value
}

data "aws_vpc_ipam_preview_next_cidr" "main_cidr" {
  for_each = var.ipv4_ipam_pool_id != null && var.ipam_netmask_length != null ? tomap({"main_vpc" = 1}) : {}
  ipam_pool_id   = var.ipv4_ipam_pool_id
  netmask_length = var.ipam_netmask_length
}