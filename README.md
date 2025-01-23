# AWS VPC Terraform Module

Terraform module which deploys an AWS VPC 

## VPC subnetting strategies covered

1. Manual VPC CIDR range allocation, with additional CIDR associations possible, by speciffying `var.vpc-cidrs`:
    - Manual subnet layer CIDR allocation with per AZ slicing of each subnet, by specifying `var.subnets`.
    - Manual subnet layer CIDR allocation with fixed per AZ subnet allocation for each subnet layer, by setting `var.fixed-subnets-only` to `true` and specifying `var.fixed-subnets` where the length of values for each subnet layer must be equal to the number of AZs used.
    - Mixed allocation where both scenarios above can be used by specifying `var.vpc-cidrs` and `var.fixed-subnets`, leaving `var.fixed-subnets-only` as default.
2. AWS IPAM allocated VPC CIDR, by specifying `var.ipv4_ipam_pool_id` and `var.ipam_netmask_length`, with dynamic subnet allocation and automatic per AZ slicing. 
    - Only one VPC CIDR is supported at this time.
    - Symetric subnet distribution for each subnet specified by `var.dynamic-subnets-names`
    - Custom subnet layer distribution specified by `var.dyanmic-subnets-newbits`, length of list needs to be equal to the length of `var.dynamic-subnets-names`
    - Oppinionated scaled subnet distribution turned on by setting `var.dynamic-subnet-symentric-newbits` to `false` while `var.dynamic-subnets-names` is left as default
3. Manual VPC CIDR, by specifying `var.dynamic-vpc-cidr`, with dynamic subnet allocation and automatic per AZ slicing. 
    - Only one VPC CIDR is supported at this time.
    - Symetric subnet distribution for each subnet specified by `var.dynamic-subnets-names`
    - Custom subnet layer distribution specified by `var.dyanmic-subnets-newbits`, length of list needs to be equal to the length of `var.dynamic-subnets-names`
    - Oppinionated scaled subnet distribution turned on by setting `var.dynamic-subnet-symentric-newbits` to `false` while `var.dynamic-subnets-names` is left as default



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.20 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flowlog_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.flow_logs_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_customer_gateway.aws_customer_gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_dx_gateway_association.aws_dx_gateway_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway_association) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.txgw_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.vpc_flowlog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flowlog_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flowlog_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.inet-gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_nat_gateway.natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.net_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.acle-permit-egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.acle-permit-ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.nacle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.accepter_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.privrt-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.pub-default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.txgw-routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_endpoint.inbound_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_endpoint.outbound_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.resolver_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.r53_outbound_rule_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_resolver_rule_association.r53_resolver_rule_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_zone.reverse_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.privrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.pubrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.sg-r53ept-inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp-opt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dns_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.private-dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.private-interface-endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.private-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_ipv4_cidr_block_association.secondary_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_vpc_peering_connection.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpn_connection.aws_vpn_connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.aws_vpn_connection_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |
| [aws_vpn_gateway.vgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_route_propagation.privrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_vpn_gateway_route_propagation.pubrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_resolver_rules.shared_resolver_rule_by_me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |
| [aws_route53_resolver_rules.shared_resolver_rule_with_me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |
| [aws_vpc_ipam_preview_next_cidr.main_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_preview_next_cidr) | data source |

## Examples

1. Manual VPC CIDR allocation, with manual subnet layer allocation, where subnet layers are sliced per Availability Zone  
```hcl
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
```  

2. Manual VPC CIDR allocation, with dynamic subnet layer allocation, where subnet layers are sliced per Availability Zone  
```hcl
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
    account = "geek37"
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
```  

3. AWS IPAM allocated VPC CIDR with dynamic subnet allocation.  
```hcl
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
```  

## Argument Reference

   * **name-vars** - Required : Map with two keys account and name. Names of elements are created based on these values.	map(string)
   ```
      variable "name-vars" {
        type = map(string)
        default = {
          account = "geek37"
          name = "dev"
        }
      }
   ```

   * **default_r53_resolver_target_ip_region** - Optional : The default region to use to determine the IP addresses in the R53 Resolver Rules target_ip map. Defaults to us-east-1.	string
   ```   
   variable "default_r53_resolver_target_ip_region" {
     default     = "us-west-1"
   }
   ```  
   * **route53_resolver_rules** - Optional : List of Route53 Resolver Rules	list{object({...})
   ```
   variable "enable_route53_outbound_endpoint" {
     default = true
   }
   
   variable "route53_resolver_endpoint_subnet" {
     default = "mgt"
   }
   
   variable "route53_resolver_rules" {
     default =[
       {
          domain_name = "geek37.com"
          rule_type   = "FORWARD"
          name        = "geek37_com"
          target_ip   = {
            us-east-1 = [
              {
                ip = "10.0.0.1"
                port =53
              },
              {
                ip = "10.0.0.2"
              }
            ]
          }
          tags        = {
            example   = "Geek37.com DNS Forwarder"
          }
       }
     ]
   }
   ```
   * **private_endpoints** - Optional : List of Maps for private AWS Endpoints Keys: name[Name of Resource IE: s3-endpoint], service[The Service IE: com.amazonaws.<REGION>.execute-api, <REGION> will be replaced with VPC Region], List of security_group IDs, List of subnet layers or Subnet IDs to deploy interfaces to. When layer is used all subnets in each layer will be used. This can cause errors if the endpoint is not available in the AZ. Use subnet IDs if this happens.	list(object({...}))
   ```
   variable "private_endpoints" {
     type        = list(object({
       name                = string
       subnets             = list(string)
       service             = string
       security_groups     = list(string)
       private_dns_enabled = bool
     }))
     default = [
        {
            name                = "storage-gateway-endpoint"
            subnets             = ["mgt"]
            service             = "com.amazonaws.<REGION>.storagegateway"
            security_group      = "sg-123456789"
            private_dns_enabled = true
        },
        {
            name                = "execute-api-endpoint"
            subnet              = ["subnet-1234567890abcdef12"]
            service             = "com.amazonaws.<REGION>.execute-api"
            security_group      = "sg-123456789|sg-987654321"
            private_dns_enabled = true
        }
      ]
    }
   ```
   * **peer_requester** - Optional : Map of maps of Peer Link requestors. The key is the name and the elements of the individual maps are peer_owner_id, peer_vpc_id, peer_cidr_blocks (list), and allow_remote_vpc_dns_resolution.	map(object({...}))
   ```
   variable "peer_requester" {
     type        = map(object({
       peer_owner_id                   = string
       peer_vpc_id                     = string
       peer_cidr_blocks                = list(string)
       allow_remote_vpc_dns_resolution = bool
     }))

     default = {
       peer_owner_id                   = "1234567890123"
       peer_vpc_id                     = "vpc-0c23f7846a96a4723"
       peer_cidr_blocks                = ["10.1.0.0/21"]
       allow_remote_vpc_dns_resolution = true
     }
   }
   ```
   * **peer_accepter** - Optional : Map of maps of Peer Link accepters. The key is the name and the elements of the individual maps are vpc_peering_connection_id, peer_cidr_blocks (list), allow_remote_vpc_dns_resolution.	map(object({...}))
   ```
   variable "peer_accepter" {
     type = "map"
     default = {
       a_dev1 = "pcx-07be323735e1a8436|10.0.0.0/20"
     }
   }
   ```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_amazonaws-com"></a> [amazonaws-com](#input\_amazonaws-com) | Optional : Ability to change principal for flowlogs from amazonaws.com to amazonaws.com.cn. | `string` | `"amazonaws.com"` |
| <a name="input_appliance_mode_support"></a> [appliance\_mode\_support](#input\_appliance\_mode\_support) | (Optional) : Whether Appliance Mode support is enabled. If enabled, a traffic flow between a source and destination uses the same Availability Zone for the VPC attachment for the lifetime of that flow. Valid values: disable, enable. Default value: disable. | `string` | `"disable"` |
| <a name="input_aws_lambda_function_name"></a> [aws\_lambda\_function\_name](#input\_aws\_lambda\_function\_name) | Optional : Lambda function name to call when sending logs to an external SEIM from CloudWatch. This is ignored if sending logs to S3. | `string` | `"null"` |
| <a name="input_block_tcp_ports"></a> [block\_tcp\_ports](#input\_block\_tcp\_ports) | Optional : Ports to block both inbound and outbound in the Public Subnet NACL. | `list(string)` | <pre>[<br/>  "20-21",<br/>  "22",<br/>  "23",<br/>  "53",<br/>  "137-139",<br/>  "445",<br/>  "1433",<br/>  "1521",<br/>  "3306",<br/>  "3389",<br/>  "5439",<br/>  "5432"<br/>]</pre> |
| <a name="input_block_udp_ports"></a> [block\_udp\_ports](#input\_block\_udp\_ports) | Optional : Ports to block both inbound and outbound in the Public Subnet NACL. | `list(string)` | <pre>[<br/>  "53"<br/>]</pre> |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | Optional : Number of days to keep logs within the cloudwatch log\_group. The default is 7 days. | `number` | `7` |
| <a name="input_default_r53_resolver_target_ip_region"></a> [default\_r53\_resolver\_target\_ip\_region](#input\_default\_r53\_resolver\_target\_ip\_region) | Optional : The default region to use to determine the IP addresses in the R53 Resolver Rules target\_ip map. | `string` | `"us-east-1"` |
| <a name="input_default_route53_resolver_rules"></a> [default\_route53\_resolver\_rules](#input\_default\_route53\_resolver\_rules) | Do not use : This defines the default values for each map entry in route53\_resolver\_rules. Do not override this. | `map` | <pre>{<br/>  "name": null,<br/>  "rule_type": "FORWARD",<br/>  "tags": {},<br/>  "target_ip": []<br/>}</pre> |
| <a name="input_default_vpn_connections"></a> [default\_vpn\_connections](#input\_default\_vpn\_connections) | Optional : This defines the default values for each map entry in vpn\_connections. Only overide this if you want to change the defaults for all VPNs. | `map` | <pre>{<br/>  "bgp_asn": 6500,<br/>  "destination_cidr_blocks": [],<br/>  "device_name": null,<br/>  "local_ipv4_network_cidr": null,<br/>  "remote_ipv4_network_cidr": null,<br/>  "static_routes_only": true,<br/>  "tags": {},<br/>  "tunnel1_dpd_timeout_action": "clear",<br/>  "tunnel1_dpd_timeout_seconds": 30,<br/>  "tunnel1_ike_versions": [<br/>    "ikev1",<br/>    "ikev2"<br/>  ],<br/>  "tunnel1_inside_cidr": null,<br/>  "tunnel1_phase1_dh_group_numbers": [<br/>    2,<br/>    14,<br/>    15,<br/>    16,<br/>    17,<br/>    18,<br/>    19,<br/>    20,<br/>    21,<br/>    22,<br/>    23,<br/>    24<br/>  ],<br/>  "tunnel1_phase1_encryption_algorithms": [<br/>    "AES128",<br/>    "AES256",<br/>    "AES128-GCM-16",<br/>    "AES256-GCM-16"<br/>  ],<br/>  "tunnel1_phase1_integrity_algorithms": [<br/>    "SHA1",<br/>    "SHA2-256",<br/>    "SHA2-384",<br/>    "SHA2-512"<br/>  ],<br/>  "tunnel1_phase1_lifetime_seconds": 28800,<br/>  "tunnel1_phase2_dh_group_numbers": [<br/>    2,<br/>    5,<br/>    14,<br/>    15,<br/>    16,<br/>    17,<br/>    18,<br/>    19,<br/>    20,<br/>    21,<br/>    22,<br/>    23,<br/>    24<br/>  ],<br/>  "tunnel1_phase2_encryption_algorithms": [<br/>    "AES128",<br/>    "AES256",<br/>    "AES128-GCM-16",<br/>    "AES256-GCM-16"<br/>  ],<br/>  "tunnel1_phase2_integrity_algorithms": [<br/>    "SHA1",<br/>    "SHA2-256",<br/>    "SHA2-384",<br/>    "SHA2-512"<br/>  ],<br/>  "tunnel1_phase2_lifetime_seconds": 3600,<br/>  "tunnel1_preshared_key": null,<br/>  "tunnel1_rekey_fuzz_percentage": 100,<br/>  "tunnel1_rekey_margin_time_seconds": 540,<br/>  "tunnel1_replay_window_size": 1024,<br/>  "tunnel1_startup_action": "add",<br/>  "tunnel2_dpd_timeout_action": "clear",<br/>  "tunnel2_dpd_timeout_seconds": 30,<br/>  "tunnel2_ike_versions": [<br/>    "ikev1",<br/>    "ikev2"<br/>  ],<br/>  "tunnel2_inside_cidr": null,<br/>  "tunnel2_phase1_dh_group_numbers": [<br/>    2,<br/>    14,<br/>    15,<br/>    16,<br/>    17,<br/>    18,<br/>    19,<br/>    20,<br/>    21,<br/>    22,<br/>    23,<br/>    24<br/>  ],<br/>  "tunnel2_phase1_encryption_algorithms": [<br/>    "AES128",<br/>    "AES256",<br/>    "AES128-GCM-16",<br/>    "AES256-GCM-16"<br/>  ],<br/>  "tunnel2_phase1_integrity_algorithms": [<br/>    "SHA1",<br/>    "SHA2-256",<br/>    "SHA2-384",<br/>    "SHA2-512"<br/>  ],<br/>  "tunnel2_phase1_lifetime_seconds": 28800,<br/>  "tunnel2_phase2_dh_group_numbers": [<br/>    2,<br/>    5,<br/>    14,<br/>    15,<br/>    16,<br/>    17,<br/>    18,<br/>    19,<br/>    20,<br/>    21,<br/>    22,<br/>    23,<br/>    24<br/>  ],<br/>  "tunnel2_phase2_encryption_algorithms": [<br/>    "AES128",<br/>    "AES256",<br/>    "AES128-GCM-16",<br/>    "AES256-GCM-16"<br/>  ],<br/>  "tunnel2_phase2_integrity_algorithms": [<br/>    "SHA1",<br/>    "SHA2-256",<br/>    "SHA2-384",<br/>    "SHA2-512"<br/>  ],<br/>  "tunnel2_phase2_lifetime_seconds": 3600,<br/>  "tunnel2_preshared_key": null,<br/>  "tunnel2_rekey_fuzz_percentage": 100,<br/>  "tunnel2_rekey_margin_time_seconds": 540,<br/>  "tunnel2_replay_window_size": 1024,<br/>  "tunnel2_startup_action": "add",<br/>  "tunnel_inside_ip_version": "ipv4"<br/>}</pre> |
| <a name="input_deploy_natgateways"></a> [deploy\_natgateways](#input\_deploy\_natgateways) | Optional : Set to true to deploy NAT gateways if pub subnet is created. Defaults to false. | `bool` | `false` |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Optional : the suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file. | `string` | `"ec2.internal"` |
| <a name="input_domain_name_servers"></a> [domain\_name\_servers](#input\_domain\_name\_servers) | Optional : List of name servers to configure in /etc/resolv.conf. The default is the AWS nameservers AmazonProvidedDNS. | `list(string)` | <pre>[<br/>  "AmazonProvidedDNS"<br/>]</pre> |
| <a name="input_dx_bgp_default_route"></a> [dx\_bgp\_default\_route](#input\_dx\_bgp\_default\_route) | Optional : A boolean flag that indicates that the default gateway will be advertised via bgp over Direct Connect and causes the script to not default routes to the NAT Gateways. | `bool` | `false` |
| <a name="input_dx_gateway_id"></a> [dx\_gateway\_id](#input\_dx\_gateway\_id) | Optional : specify the Direct Connect Gateway ID to associate the VGW with. | `string` | `"null"` |
| <a name="input_dyanmic-subnets-newbits"></a> [dyanmic-subnets-newbits](#input\_dyanmic-subnets-newbits) | Optional : Orderred list of newbits per each subnet layer specified in the dynamic-subnets-names list. Length must be same as the dynamic-subnets-names list. | `list` | `[]` |
| <a name="input_dynamic-subnet-symentric-newbits"></a> [dynamic-subnet-symentric-newbits](#input\_dynamic-subnet-symentric-newbits) | Optional : Switch between symetric subnetting (every subnet same size) and Four Subnets / 3 AZs cascading subnetting. | `bool` | `true` |
| <a name="input_dynamic-subnets-names"></a> [dynamic-subnets-names](#input\_dynamic-subnets-names) | Optional : Orderred list of subnet names to be used to dynamically slice a VPC CIDR block to subnets distributed per speciffied AZs. | `list` | <pre>[<br/>  "k8s",<br/>  "prv",<br/>  "pub",<br/>  "fwl"<br/>]</pre> |
| <a name="input_dynamic-vpc-cidr"></a> [dynamic-vpc-cidr](#input\_dynamic-vpc-cidr) | Optional : VPC CIDR to be used for dynamic subnetting | `string` | `null` |
| <a name="input_enable-dynamodb-endpoint"></a> [enable-dynamodb-endpoint](#input\_enable-dynamodb-endpoint) | Optional : Enable the DynamoDB Endpoint | `bool` | `false` |
| <a name="input_enable-s3-endpoint"></a> [enable-s3-endpoint](#input\_enable-s3-endpoint) | Optional : Enable the S3 Endpoint | `bool` | `false` |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Optional : A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true. | `bool` | `true` |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Optional : A boolean flag to enable/disable DNS support in the VPC. Defaults true. | `bool` | `true` |
| <a name="input_enable_flowlog"></a> [enable\_flowlog](#input\_enable\_flowlog) | Optional : A boolean flag to enable/disable VPC flowlogs. | `bool` | `false` |
| <a name="input_enable_pub_route_propagation"></a> [enable\_pub\_route\_propagation](#input\_enable\_pub\_route\_propagation) | Optional : A boolean flag that indicates that the routes should be propagated to the pub routing table. Defaults to False. | `bool` | `false` |
| <a name="input_enable_route53_inbound_endpoint"></a> [enable\_route53\_inbound\_endpoint](#input\_enable\_route53\_inbound\_endpoint) | Optional : A boolean flag to enable/disable Route53 Resolver Endpoint. Defaults false. | `bool` | `false` |
| <a name="input_enable_route53_outbound_endpoint"></a> [enable\_route53\_outbound\_endpoint](#input\_enable\_route53\_outbound\_endpoint) | Optional : A boolean flag to enable/disable Route53 Outbound Endpoint. Defaults false. | `bool` | `false` |
| <a name="input_enable_route53_reverse_zones"></a> [enable\_route53\_reverse\_zones](#input\_enable\_route53\_reverse\_zones) | Optional : A boolean flag to enable/disable creation of reverse DNS zones for all /24 networks in the VPC. Anything smaller than a /24 will be ignored. Default is false | `bool` | `false` |
| <a name="input_enable_route53_shared_resolver_rules"></a> [enable\_route53\_shared\_resolver\_rules](#input\_enable\_route53\_shared\_resolver\_rules) | Optional : Enable Route53 resolver rule associations. Defaults to false | `bool` | `false` |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Optional : Create a new VPN Gateway. Defaults to true. | `bool` | `true` |
| <a name="input_exclude_resolver_rule_ids"></a> [exclude\_resolver\_rule\_ids](#input\_exclude\_resolver\_rule\_ids) | Optional : A list of resolve rule IDs to exclude from the resolve rule associations. | `list(string)` | `[]` |
| <a name="input_fixed-name"></a> [fixed-name](#input\_fixed-name) | Optional : Keys must match keys in subnets and values are the name of subnets for each AZ. The number of subnets specified in each list needs to match the number of AZs. 'pub' is the only special name used. | `map(list(string))` | `{}` |
| <a name="input_fixed-subnets"></a> [fixed-subnets](#input\_fixed-subnets) | Optional : Keys must match keys in subnets and values are the list of subnets for each AZ. The number of subnets specified in each list needs to match the number of AZs. 'pub' is the only special name used. | `map(list(string))` | `{}` |
| <a name="input_fixed-subnets-only"></a> [fixed-subnets-only](#input\_fixed-subnets-only) | Optional : Allows the use of fixed subnets only, ignoring the subnets variable | `bool` | `false` |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | Optional : Required if enable\_flowlog = true and destination type s3. The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create\_flow\_log\_cloudwatch\_log\_group is set to false this argument must be provided. | `string` | `""` |
| <a name="input_flow_log_destination_type"></a> [flow\_log\_destination\_type](#input\_flow\_log\_destination\_type) | Optional : Type of flow log destination. Can be s3 or cloud-watch-logs. Defaults to S3. | `string` | `"s3"` |
| <a name="input_flow_log_file_format"></a> [flow\_log\_file\_format](#input\_flow\_log\_file\_format) | (Optional) The format for the flow log. Valid values: `plain-text`, `parquet`. | `string` | `"plain-text"` |
| <a name="input_flow_log_filter"></a> [flow\_log\_filter](#input\_flow\_log\_filter) | Optional : CloudWatch subscription filter to match flow logs. | `string` | `""` |
| <a name="input_flow_log_format"></a> [flow\_log\_format](#input\_flow\_log\_format) | Optional : VPC flow log format. | `string` | `"${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status} ${vpc-id} ${subnet-id} ${instance-id} ${tcp-flags} ${type} ${pkt-srcaddr} ${pkt-dstaddr} ${region} ${az-id} ${sublocation-type} ${sublocation-id} ${pkt-src-aws-service} ${pkt-dst-aws-service} ${flow-direction} ${traffic-path}"` |
| <a name="input_flow_log_hive_compatible_partitions"></a> [flow\_log\_hive\_compatible\_partitions](#input\_flow\_log\_hive\_compatible\_partitions) | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3. | `bool` | `false` |
| <a name="input_flow_log_max_aggregation_interval"></a> [flow\_log\_max\_aggregation\_interval](#input\_flow\_log\_max\_aggregation\_interval) | Optional : The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds. Defaults to 600. | `number` | `600` |
| <a name="input_flow_log_per_hour_partition"></a> [flow\_log\_per\_hour\_partition](#input\_flow\_log\_per\_hour\_partition) | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries. | `bool` | `false` |
| <a name="input_flow_log_traffic_type"></a> [flow\_log\_traffic\_type](#input\_flow\_log\_traffic\_type) | Optional : The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL. | `string` | `"ALL"` |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | Optional : A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr. | `string` | `"default"` |
| <a name="input_ipam_netmask_length"></a> [ipam\_netmask\_length](#input\_ipam\_netmask\_length) | (Optional) The length of the IPv4 IPAM generated CIDR you want to allocate to this VPC. | `number` | `null` |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` |
| <a name="input_name-vars"></a> [name-vars](#input\_name-vars) | Required : Map with two keys account and name. Names of elements are created based on these values. | `map(string)` | n/a |
| <a name="input_network_acl_rules"></a> [network\_acl\_rules](#input\_network\_acl\_rules) | Optional : Map of Map of ingress or egress rules to add to Public Subnet's NACL. | <pre>map(object({<br/>    rule_number = number<br/>    egress      = bool<br/>    protocol    = string<br/>    rule_action = string<br/>    cidr_block  = string<br/>    from_port   = number<br/>    to_port     = number<br/>    icmp_type   = number<br/>  }))</pre> | `{}` |
| <a name="input_ntp_servers"></a> [ntp\_servers](#input\_ntp\_servers) | Optional : List of NTP servers to configure. The default is an emppty list. | `list(string)` | `[]` |
| <a name="input_override_default_security_group"></a> [override\_default\_security\_group](#input\_override\_default\_security\_group) | Optional : Takes over the rule set of the VPC's default Security Group and removes all rules. Defaults false. | `bool` | `true` |
| <a name="input_peer_accepter"></a> [peer\_accepter](#input\_peer\_accepter) | Optional : Map of maps of Peer Link accepters. The key is the name and the elements of the individual maps are vpc\_peering\_connection\_id, peer\_cidr\_blocks (list), allow\_remote\_vpc\_dns\_resolution. | <pre>map(object({<br/>    vpc_peering_connection_id       = string<br/>    peer_cidr_blocks                = list(string)<br/>    allow_remote_vpc_dns_resolution = bool<br/>  }))</pre> | `{}` |
| <a name="input_peer_requester"></a> [peer\_requester](#input\_peer\_requester) | Optional : Map of maps of Peer Link requestors. The key is the name and the elements of the individual maps are peer\_owner\_id, peer\_vpc\_id, peer\_cidr\_blocks (list), and allow\_remote\_vpc\_dns\_resolution. | <pre>map(object({<br/>    peer_owner_id                   = string<br/>    peer_vpc_id                     = string<br/>    peer_cidr_blocks                = list(string)<br/>    allow_remote_vpc_dns_resolution = bool<br/>  }))</pre> | `{}` |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Optional : List of Maps for private AWS Endpoints Keys: name[Name of Resource IE: s3-endpoint], service[The Service IE: com.amazonaws.<REGION>.execute-api, <REGION> will be replaced with VPC Region], List of security\_group IDs, List of subnet layers or Subnet IDs to deploy interfaces to. When layer is used all subnets in each layer will be used. This can cause errors if the endpoint is not available in the AZ. Use subnet IDs if this happens. | <pre>list(object({<br/>    name                = string<br/>    subnets             = list(string)<br/>    service             = string<br/>    security_groups     = list(string)<br/>    private_dns_enabled = bool<br/>  }))</pre> | `[]` |
| <a name="input_pub_layer"></a> [pub\_layer](#input\_pub\_layer) | Optional : Specifies the name of the public layer. Defaults to pub. | `string` | `"pub"` |
| <a name="input_region"></a> [region](#input\_region) | Optional : The AWS Region to deploy the VPC to. Defaults to us-east-1 | `string` | `"us-east-1"` |
| <a name="input_reserve_azs"></a> [reserve\_azs](#input\_reserve\_azs) | Optional : The number of subnets to compute the IP allocations for. If greater than the existing numnber of availbility zones in the zones list it will reserve space for additional subnets if less then it will only allocate for the existing AZs. The default is 0. | `number` | `0` |
| <a name="input_resource-tags"></a> [resource-tags](#input\_resource-tags) | Optional : A map of maps of tags to assign to specifc resources. This can be used to override globally specified or calculated tags such as the name. The key must be one of the following: aws\_vpc, aws\_vpn\_gateway, aws\_subnet, aws\_network\_acl, aws\_internet\_gateway, aws\_cloudwatch\_log\_group, aws\_vpc\_dhcp\_options, aws\_route\_table, aws\_route53\_resolver\_endpoint, aws\_lb. | `map(map(string))` | `{}` |
| <a name="input_route53_resolver_endpoint_cidr_blocks"></a> [route53\_resolver\_endpoint\_cidr\_blocks](#input\_route53\_resolver\_endpoint\_cidr\_blocks) | Optional : A list of the source CIDR blocks to allow to commuicate with the Route53 Resolver Endpoint. Defaults 0.0.0.0/0. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> |
| <a name="input_route53_resolver_endpoint_subnet"></a> [route53\_resolver\_endpoint\_subnet](#input\_route53\_resolver\_endpoint\_subnet) | Optional : The subnet to install Route53 Resolver Endpoint , the default is mgt but must exist as a key in the variable subnets. | `string` | `"mgt"` |
| <a name="input_route53_resolver_rules"></a> [route53\_resolver\_rules](#input\_route53\_resolver\_rules) | Optional : List of Route53 Resolver Rules | `list` | `[]` |
| <a name="input_subnet-tags"></a> [subnet-tags](#input\_subnet-tags) | Optional : A map of maps of tags to assign to specifc subnet resource.  The key but be the same as the key in variable subnets. | `map(map(string))` | `{}` |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Optional : Keys are used for subnet names and values are the subnets for the various layers. These will be divided by the number of AZs based on ceil(log(length(var.zones[var.region]),2)). 'pub' is the only special name used for the public subnet and must be specified first. | `map(string)` | <pre>{<br/>  "app": "10.0.2.0/24",<br/>  "db": "10.0.3.0/24",<br/>  "mgt": "10.0.4.0/24",<br/>  "pub": "10.0.0.0/24",<br/>  "web": "10.0.1.0/24"<br/>}</pre> |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional : A map of tags to assign to the resource. | `map(string)` | `{}` |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Optional : specify the Transit Gateway ID within the same account to associate the VPC with. | `string` | `"null"` |
| <a name="input_transit_gateway_routes"></a> [transit\_gateway\_routes](#input\_transit\_gateway\_routes) | Optional : specify the list of CIDR blocks to route to the Transit Gateway. | `list(string)` | `[]` |
| <a name="input_txgw_layer"></a> [txgw\_layer](#input\_txgw\_layer) | Optional : Specifies the name of the layer to connect the TXGW to. Defaults to mgt. | `string` | `"mgt"` |
| <a name="input_vpc-cidrs"></a> [vpc-cidrs](#input\_vpc-cidrs) | Required : List of CIDRs to apply to the VPC. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> |
| <a name="input_vpc-name"></a> [vpc-name](#input\_vpc-name) | Optional : Override the calculated VPC name | `string` | `"null"` |
| <a name="input_vpn_connections"></a> [vpn\_connections](#input\_vpn\_connections) | Optional : A map of a map with the settings for each VPN.  The key will be the name of the VPN | `map` | `{}` |
| <a name="input_zones"></a> [zones](#input\_zones) | Optional : AWS Regions and Availability Zones | `map(list(string))` | <pre>{<br/>  "ap-northeast-1": [<br/>    "ap-northeast-1a",<br/>    "ap-northeast-1b",<br/>    "ap-northeast-1c"<br/>  ],<br/>  "ap-northeast-2": [<br/>    "ap-northeast-2a",<br/>    "ap-northeast-2b",<br/>    "ap-northeast-2c"<br/>  ],<br/>  "ap-south-1": [<br/>    "ap-south-1a",<br/>    "ap-south-1b",<br/>    "ap-south-1c"<br/>  ],<br/>  "ap-southeast-1": [<br/>    "ap-southeast-1a",<br/>    "ap-southeast-1b",<br/>    "ap-southeast-1c"<br/>  ],<br/>  "ap-southeast-2": [<br/>    "ap-southeast-2a",<br/>    "ap-southeast-2b",<br/>    "ap-southeast-2c"<br/>  ],<br/>  "ca-central-1": [<br/>    "ca-central-1a",<br/>    "ca-central-1b",<br/>    "ca-central-1d"<br/>  ],<br/>  "cn-north-1": [<br/>    "cn-north-1a",<br/>    "cn-north-1b"<br/>  ],<br/>  "cn-northwest-1": [<br/>    "cn-northwest-1a",<br/>    "cn-northwest-1b",<br/>    "cn-northwest-1c"<br/>  ],<br/>  "eu-central-1": [<br/>    "eu-central-1a",<br/>    "eu-central-1b",<br/>    "eu-central-1c"<br/>  ],<br/>  "eu-west-1": [<br/>    "eu-west-1a",<br/>    "eu-west-1b",<br/>    "eu-west-1c"<br/>  ],<br/>  "eu-west-2": [<br/>    "eu-west-2a",<br/>    "eu-west-2b",<br/>    "eu-west-2c"<br/>  ],<br/>  "sa-east-1": [<br/>    "sa-east-1a",<br/>    "sa-east-1b",<br/>    "sa-east-1c"<br/>  ],<br/>  "us-east-1": [<br/>    "us-east-1a",<br/>    "us-east-1b",<br/>    "us-east-1c"<br/>  ],<br/>  "us-east-2": [<br/>    "us-east-2a",<br/>    "us-east-2b",<br/>    "us-east-2c"<br/>  ],<br/>  "us-gov-east-1": [<br/>    "us-gov-east-1a",<br/>    "us-gov-east-1c",<br/>    "us-gov-east-1b"<br/>  ],<br/>  "us-gov-west-1": [<br/>    "us-gov-west-1a",<br/>    "us-gov-west-1c",<br/>    "us-gov-west-1b"<br/>  ],<br/>  "us-west-1": [<br/>    "us-west-1a",<br/>    "us-west-1b",<br/>    "us-west-1c"<br/>  ],<br/>  "us-west-2": [<br/>    "us-west-2a",<br/>    "us-west-2b",<br/>    "us-west-2c"<br/>  ]<br/>}</pre> |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | string : Account Number the VPC was deployed to. |
| <a name="output_available_availability_zone"></a> [available\_availability\_zone](#output\_available\_availability\_zone) | list(string) : List of teh available availability zones in the region. |
| <a name="output_aws_customer_gateway"></a> [aws\_customer\_gateway](#output\_aws\_customer\_gateway) | Resource aws\_customer\_gateway [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) |
| <a name="output_aws_dynamodb_endpoint"></a> [aws\_dynamodb\_endpoint](#output\_aws\_dynamodb\_endpoint) | Resource aws\_vpc\_endpoint for DynamoDB [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| <a name="output_aws_eip"></a> [aws\_eip](#output\_aws\_eip) | Resource aws\_eip [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) |
| <a name="output_aws_internet_gateway"></a> [aws\_internet\_gateway](#output\_aws\_internet\_gateway) | Resource aws\_internet\_gateway [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway) |
| <a name="output_aws_nat_gateway"></a> [aws\_nat\_gateway](#output\_aws\_nat\_gateway) | Resource aws\_nat\_gateway [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) |
| <a name="output_aws_network_acl"></a> [aws\_network\_acl](#output\_aws\_network\_acl) | Resource aws\_network\_acl [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) |
| <a name="output_aws_s3_endpoint"></a> [aws\_s3\_endpoint](#output\_aws\_s3\_endpoint) | Resource aws\_vpc\_endpoint for S3 [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| <a name="output_aws_vpc"></a> [aws\_vpc](#output\_aws\_vpc) | Resource aws\_vpc - [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) |
| <a name="output_aws_vpc_dhcp_options"></a> [aws\_vpc\_dhcp\_options](#output\_aws\_vpc\_dhcp\_options) | Resource aws\_vpc\_dhcp\_options [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) |
| <a name="output_aws_vpc_endpoint"></a> [aws\_vpc\_endpoint](#output\_aws\_vpc\_endpoint) | Resource aws\_vpc\_endpoint for Interface Endpoints [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| <a name="output_aws_vpc_peering_connection"></a> [aws\_vpc\_peering\_connection](#output\_aws\_vpc\_peering\_connection) | Resource aws\_vpc\_peering\_connection [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) |
| <a name="output_aws_vpc_peering_connection_accepter"></a> [aws\_vpc\_peering\_connection\_accepter](#output\_aws\_vpc\_peering\_connection\_accepter) | Resource aws\_vpc\_peering\_connection\_accepter [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) |
| <a name="output_aws_vpn_connection"></a> [aws\_vpn\_connection](#output\_aws\_vpn\_connection) | Resource aws\_vpn\_connection [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) |
| <a name="output_aws_vpn_gateway"></a> [aws\_vpn\_gateway](#output\_aws\_vpn\_gateway) | Resource aws\_vpn\_gateway [see](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) |
| <a name="output_nacl_rules"></a> [nacl\_rules](#output\_nacl\_rules) | map(object(...)) : Data used to create the Public Subnet Network Access Control List. |
| <a name="output_peerlink_accepter_routes"></a> [peerlink\_accepter\_routes](#output\_peerlink\_accepter\_routes) | list(map(string)) : Data used to create routes for accepted peer links. |
| <a name="output_peerlink_requester_routes"></a> [peerlink\_requester\_routes](#output\_peerlink\_requester\_routes) | list(map(string)) : Data used to create routes for requested peer links. |
| <a name="output_route53_reverse_zones"></a> [route53\_reverse\_zones](#output\_route53\_reverse\_zones) | list(string) : Data used to create Route53 reverse DNS zones. |
| <a name="output_routetable_ids"></a> [routetable\_ids](#output\_routetable\_ids) | map(list(string)) : |
| <a name="output_subnet_data"></a> [subnet\_data](#output\_subnet\_data) | list(object(...)) : Data used to create the subnets and other related items like routing tables. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | map(list(string)) : Map with keys the same as subnets and value list of subnet IDs |
| <a name="output_txgw_routes"></a> [txgw\_routes](#output\_txgw\_routes) | list(map(string)) : Data used to create routes that point to the Transit Gateway. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | string : The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | string : The name of the VPC |
| <a name="output_vpn_connection_routes"></a> [vpn\_connection\_routes](#output\_vpn\_connection\_routes) | list(map(string)) : Data used to create static routes that point VPN connections. |
<!-- END_TF_DOCS -->

## Credits

This module is inspired by [https://github.com/fstuck37/terraform-aws-vpc2](https://github.com/fstuck37/terraform-aws-vpc2)

## License

GPL-3.0 Licensed. See [LICENSE](./LICENSE) for full details.