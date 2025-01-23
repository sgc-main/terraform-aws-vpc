locals {
  emptymaps               = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
  resource_list           = ["aws_vpc", "aws_vpn_gateway", "aws_subnet", "aws_network_acl", "aws_internet_gateway", "aws_cloudwatch_log_group", "aws_vpc_dhcp_options", "aws_route_table", "aws_route53_resolver_endpoint", "aws_lb", "aws_flow_log", "aws_nat_gateway"]
  private_endpoints_names = [for endpoint in var.private_endpoints : endpoint.name]
  empty-resource-tags     = zipmap(distinct(concat(local.private_endpoints_names, local.resource_list)), slice(local.emptymaps, 0, length(distinct(concat(local.private_endpoints_names, local.resource_list)))))
  resource-tags           = merge(local.empty-resource-tags, var.resource-tags)

  flow_log_destination_arn = (var.enable_flowlog && var.flow_log_destination_arn != "") ? var.flow_log_destination_arn : (var.flow_log_destination_type != "s3") ? lookup(lookup(aws_cloudwatch_log_group.flowlog_group, var.region, {}), "arn", null) : "------ Must Specify S3 ARN ------"
  flow_log_iam_role_arn    = var.flow_log_traffic_type == "s3" ? null : lookup(lookup(aws_iam_role.flowlog_role, "${var.name-vars["account"]}-${replace(var.region, "-", "")}-${var.name-vars["name"]}-flow-log-role", {}), "arn", null)

  dynamic-vpc-cidr = var.ipv4_ipam_pool_id != null ? data.aws_vpc_ipam_preview_next_cidr.main_cidr["main_vpc"].cidr  : var.dynamic-vpc-cidr != null ? var.dynamic-vpc-cidr : null
  dynamic_subnet_newbits = local.dynamic-vpc-cidr != null ? length(var.dyanmic-subnets-newbits) != 0 ? flatten([for i, s in var.dyanmic-subnets-newbits : [ for ii, z in var.zones[var.region] : [s]] ]) : flatten([for i, s in var.dynamic-subnets-names : [
    for ii, z in var.zones[var.region] : 
      var.dynamic-subnet-symentric-newbits == true ?
        [ ceil(log(length(var.dynamic-subnets-names) * length(var.zones[var.region]), 2)) ] :
        [ 2 * (i + 1) ]
    ]
  ]) : []
  
  dynamic_subnet_cidr_list = local.dynamic-vpc-cidr != null ? cidrsubnets(local.dynamic-vpc-cidr, local.dynamic_subnet_newbits...) : []
  dynamic_subnet_map = local.dynamic-vpc-cidr != null ? {for i, s in var.dynamic-subnets-names : 
    s => flatten([ slice(local.dynamic_subnet_cidr_list, i * length(var.zones[var.region]), i * length(var.zones[var.region]) + length(var.zones[var.region])) ])
  } : {}

  fixed-subnets = local.dynamic-vpc-cidr != null ? local.dynamic_subnet_map : var.fixed-subnets
  subnet_data = (var.fixed-subnets-only == true || var.ipv4_ipam_pool_id != null || var.dynamic-vpc-cidr != null) ? flatten([
        for i, sn in keys(local.fixed-subnets) : [
          for ii, az in var.zones[var.region] : {
            az              = az
            layer           = sn
            name            = format("%02s", "${var.name-vars["account"]}-${var.name-vars["name"]}-${sn}-${element(split("-", az), length(split("-", az)) - 1)}")
            index           = (i * length(var.zones[var.region])) + ii
            layer_index     = i
            subnet_index    = ii
            layer_cidr      = local.fixed-subnets[sn][ii]
            layer_cidr_size = element(split("/", local.fixed-subnets[sn][ii]), 1)
            azs_allocated   = pow(2, ceil(log(max(var.reserve_azs, length(var.zones[var.region])), 2)))
            subnet_cidr     = contains(keys(local.fixed-subnets), sn) ? local.fixed-subnets[sn][ii] : cidrsubnet(var.subnets[sn], ceil(log(max(var.reserve_azs, length(var.zones[var.region])), 2)), ii)
            subnet-tags = merge(
              var.tags,
              tomap({ "Name" = contains(keys(var.fixed-name), sn) ? var.fixed-name[sn][ii] : format("%02s", "${var.name-vars["account"]}-${var.name-vars["name"]}-${sn}-${element(split("-", az), length(split("-", az)) - 1)}") }),
              local.subnet-tags[sn], local.resource-tags["aws_subnet"]
            )
        }]
      ]) : flatten([
        for i, sn in keys(var.subnets) : [
          for ii, az in var.zones[var.region] : {
            az              = az
            layer           = sn
            name            = format("%02s", "${var.name-vars["account"]}-${var.name-vars["name"]}-${sn}-${element(split("-", az), length(split("-", az)) - 1)}")
            index           = (i * length(var.zones[var.region])) + ii
            layer_index     = i
            subnet_index    = ii
            layer_cidr      = var.subnets[sn]
            layer_cidr_size = element(split("/", var.subnets[sn]), 1)
            azs_allocated   = pow(2, ceil(log(max(var.reserve_azs, length(var.zones[var.region])), 2)))
            subnet_cidr     = contains(keys(local.fixed-subnets), sn) ? local.fixed-subnets[sn][ii] : cidrsubnet(var.subnets[sn], ceil(log(max(var.reserve_azs, length(var.zones[var.region])), 2)), ii)
            subnet-tags = merge(
              var.tags,
              tomap({ "Name" = contains(keys(var.fixed-name), sn) ? var.fixed-name[sn][ii] : format("%02s", "${var.name-vars["account"]}-${var.name-vars["name"]}-${sn}-${element(split("-", az), length(split("-", az)) - 1)}") }),
              local.subnet-tags[sn], local.resource-tags["aws_subnet"]
            )
        }]
      ])

  subnet-order      = (var.fixed-subnets-only == true || var.ipv4_ipam_pool_id != null || var.dynamic-vpc-cidr != null) ? coalescelist(keys(local.fixed-subnets)) : coalescelist(keys(var.subnets))
  empty-subnet-tags = zipmap(local.subnet-order, slice(local.emptymaps, 0, length(local.subnet-order)))
  subnet-tags       = merge(local.empty-subnet-tags, var.subnet-tags)

  nacl_rules = merge(
    { for i, rule in var.block_tcp_ports : "tcp-e-${rule}" => {
      rule_number = 32700 - (i * 100)
      egress      = true
      protocol    = "tcp"
      rule_action = "deny"
      cidr_block  = "0.0.0.0/0"
      from_port   = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 0)
      to_port     = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 1)
      }
    },
    { for i, rule in var.block_udp_ports : "udp-e-${rule}" => {
      rule_number = 32700 - (i * 100) - (length(var.block_tcp_ports) * 100)
      egress      = true
      protocol    = "udp"
      rule_action = "deny"
      cidr_block  = "0.0.0.0/0"
      from_port   = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 0)
      to_port     = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 1)
      }
    },
    { for i, rule in var.block_tcp_ports : "tcp-i-${rule}" => {
      rule_number = 32700 - (i * 100)
      egress      = false
      protocol    = "tcp"
      rule_action = "deny"
      cidr_block  = "0.0.0.0/0"
      from_port   = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 0)
      to_port     = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 1)
      }
    },
    { for i, rule in var.block_udp_ports : "udp-i-${rule}" => {
      rule_number = 32700 - (i * 100) - (length(var.block_tcp_ports) * 100)
      egress      = false
      protocol    = "udp"
      rule_action = "deny"
      cidr_block  = "0.0.0.0/0"
      from_port   = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 0)
      to_port     = length(split("-", rule)) < 2 ? rule : element(split("-", rule), 1)
      }
    },
    var.network_acl_rules
  )

  txgw_routes = flatten([
    for rt in var.transit_gateway_routes : [
      for az in var.zones[var.region] : {
        name  = "${az}-${rt}"
        route = rt
        az    = az
      }
    if var.transit_gateway_id != "null"]
  ])

  peerlink_accepter_routes = flatten([
    for az in var.zones[var.region] : [
      for key, value in var.peer_accepter : [
        for cidr in value.peer_cidr_blocks : {
          name                      = "${az}-${replace(cidr, "/", "-")}"
          peer_link_name            = key
          az                        = az
          vpc_peering_connection_id = value.vpc_peering_connection_id
          cidr                      = cidr
        }
      ]
    ]
  ])

  peerlink_requester_routes = flatten([
    for az in var.zones[var.region] : [
      for key, value in var.peer_requester : [
        for cidr in value.peer_cidr_blocks : {
          name           = "${az}-${replace(cidr, "/", "-")}"
          peer_link_name = key
          az             = az
          cidr           = cidr
        }
      ]
    ]
  ])

  vpn_connection_routes = flatten([
    for az in var.zones[var.region] : [
      for vpn, value in var.vpn_connections : [
        for cidr in merge(var.default_vpn_connections, var.vpn_connections[vpn]).destination_cidr_blocks : {
          name     = "${az}-${replace(cidr, "/", "-")}"
          vpn_name = vpn
          az       = az
          cidr     = cidr
        }
      ]
    ]
  ])

  route53_reverse_zones = var.enable_route53_reverse_zones == true ? flatten([
    for cidr in var.vpc-cidrs : [
      for n in range(pow(2, (24 - tonumber(element(split("/", cidr), 1))))) : [
        cidrsubnet(cidr, (24 - tonumber(element(split("/", cidr), 1))), n)
      ]
    if tonumber(element(split("/", cidr), 1)) <= 24]
  ]) : []

  subnet_ids = {
    for layer in keys(var.subnets) :
    layer => [
      for sd in local.subnet_data :
      aws_subnet.subnets[sd.name].id
    if sd.layer == layer]
  }

  subnet_cidrs = {
    for layer in keys(var.subnets) :
    layer => [
      for sd in local.subnet_data :
      aws_subnet.subnets[sd.name].cidr_block
    if sd.layer == layer]
  }

  routetable_ids = {
    for layer in keys(var.subnets) :
    layer => distinct([
      for sd in local.subnet_data :
      sd.layer == var.pub_layer ? aws_route_table.pubrt[sd.az].id : aws_route_table.privrt[sd.az].id
    if sd.layer == layer])
  }
}
