   * **name-vars** - Required : Map with two keys account and name. Names of elements are created based on these values.	map(string)
   ```
      variable "name-vars" {
        type = map(string)
        default = {
          account = "tst"
          name    = "dev"
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
          domain_name = "tst.com"
          rule_type   = "FORWARD"
          name        = "tst_com"
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
            example   = "tst.com DNS Forwarder"
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
            subnets             = ["mgt"]
            service             = "storage-gateway"
            private_dns_enabled = true
        },
        {
            subnet              = ["subnet-1234567890abcdef12"]
            service             = "execute-api"
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
