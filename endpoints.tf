resource "aws_vpc_endpoint" "private-s3" {
  for_each = { for s3 in ["com.amazonaws.${var.region}.s3"] : s3 => s3
  if var.enable-s3-endpoint }
  vpc_id          = aws_vpc.main_vpc.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [for rt in aws_route_table.privrt : rt.id]
}

resource "aws_vpc_endpoint" "private-dynamodb" {
  for_each = { for db in ["com.amazonaws.${var.region}.dynamodb"] : db => db
  if var.enable-dynamodb-endpoint }
  vpc_id          = aws_vpc.main_vpc.id
  service_name    = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [for rt in aws_route_table.privrt : rt.id]
}

resource "aws_security_group" "vpc_endpoints" {
  for_each = length(var.private_endpoints) > 0 ? { "create" = true } : {}

  name_prefix = "${local.vpc_name}-endpoints-"
  description = "Allow all in-VPC traffic for all VPC interface endpoints"
  vpc_id      = aws_vpc.main_vpc.id
  revoke_rules_on_delete = true

  ingress {
    description = "Allow all from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${local.vpc_name}-endpoints-sg" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "private-interface-endpoints" {
  for_each            = { for endpoint in var.private_endpoints : "${local.vpc_name}-${replace(endpoint.service, "-", "")}-endpoint" => endpoint }
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.${var.region}.${each.value.service}"
  private_dns_enabled = each.value.private_dns_enabled
  vpc_endpoint_type   = "Interface"
  subnet_ids = concat([for i in local.subnet_data : aws_subnet.subnets[i.name].id if contains(each.value.subnets, i.layer)],
  [for i in aws_subnet.subnets : i.id if contains(each.value.subnets, i.id)])
  security_group_ids = compact(
    concat(
      [aws_security_group.vpc_endpoints["create"].id],
      try(each.value.security_groups, [])
    )
  )
  
  tags = merge(
    var.tags,
    tomap({ "Name" = "${local.vpc_name}-${replace(each.value.service, "-", "")}-endpoint" }),
    local.resource-tags["${local.vpc_name}-${replace(each.value.service, "-", "")}-endpoint"]
  )
}

