# AWS Application and Network Load Balancer (ALB & NLB) Terraform module

Terraform module which creates Application and Network Load Balancer resources on AWS.

## Usage
```hcl
module "network-loadbalance" {
  source             = "git@github.com:examplae/aws-loadbalance.git"
  master_prefix      = "dev"
  aws_region         = "ap-southeast-1"
  assume_role        = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  elb_name           = "nlb-proxy"
  load_balancer_type = "network"
  internal           = true
  http_tcp_listeners = [
    {
      port               = 22
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 21
      protocol           = "TCP"
      target_group_index = 1
    }
  ]

  target_groups = [
    {
      name             = "nlb-to-22"
      backend_protocol = "TCP"
      backend_port     = 22
      target_type      = "ip"
      targets = {
        proxy_ec2 = {
          target_id         = "192.168.1.1"
          port              = 22
        }
      }
    },
    {
      name             = "nlb-to-21"
      backend_protocol = "TCP"
      backend_port     = 21
      target_type      = "ip"
      targets = {
        proxy_ec2 = {
          target_id         = "192.168.2.2"
          port              = 21
          availability_zone = "all"
        }
      }
    }
  ]
  vpc_id                           = "vpc-123456789"
  subnets                          = ["subnet-123456", "subnet-987654"]
  enable_cross_zone_load_balancing = true
  create_s3                        = true
  s3_bucket_name                   = "nlb-proxy"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3"></a> [s3](#module\_s3) | git::https://github.com/tin-nguyen71/aws-s3.git | v1.1.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | git::https://github.com//aws-security-group.git | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.elb_http_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.elb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_listener_rule.http_tcp_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.https_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.lb_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.elb_logs_bucket_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | Map containing access logging configuration for load balancer. | `map(string)` | `{}` | no |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | A boolean flag to add record to route53 | `bool` | `false` | no |
| <a name="input_create_elb"></a> [create\_elb](#input\_create\_elb) | Controls if the Load Balancer should be created | `bool` | `true` | no |
| <a name="input_create_s3"></a> [create\_s3](#input\_create\_s3) | A boolean flag to determine whether to create S3 bucket | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | A boolean flag to determine whether to create Security Group. | `bool` | `true` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. | `string` | `"defensive"` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Route53 parent zone ID. | `string` | `null` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `false` | no |
| <a name="input_elb_name"></a> [elb\_name](#input\_elb\_name) | The resource name and Name tag of the load balancer. | `string` | `null` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Indicates whether cross zone load balancing should be enabled in application load balancers. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. | `bool` | `true` | no |
| <a name="input_enable_waf_fail_open"></a> [enable\_waf\_fail\_open](#input\_enable\_waf\_fail\_open) | Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF | `bool` | `false` | no |
| <a name="input_extra_ssl_certs"></a> [extra\_ssl\_certs](#input\_extra\_ssl\_certs) | A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate\_arn, https\_listener\_index (the index of the listener within https\_listeners which the cert applies toward). | `list(map(string))` | `[]` | no |
| <a name="input_http_tcp_listener_rules"></a> [http\_tcp\_listener\_rules](#input\_http\_tcp\_listener\_rules) | A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, http\_tcp\_listener\_index (default to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_http_tcp_listeners"></a> [http\_tcp\_listeners](#input\_http\_tcp\_listeners) | A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target\_group\_index (defaults to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_https_listener_rules"></a> [https\_listener\_rules](#input\_https\_listener\_rules) | A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https\_listener\_index (default to https\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_https_listeners"></a> [https\_listeners](#input\_https\_listeners) | A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate\_arn. Optional key/values: ssl\_policy (defaults to ELBSecurityPolicy-2016-08), target\_group\_index (defaults to https\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean determining if the load balancer is internal or externally facing. | `bool` | `true` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| <a name="input_listener_ssl_policy_default"></a> [listener\_ssl\_policy\_default](#input\_listener\_ssl\_policy\_default) | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_load_balancer_create_timeout"></a> [load\_balancer\_create\_timeout](#input\_load\_balancer\_create\_timeout) | Timeout value when creating the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_delete_timeout"></a> [load\_balancer\_delete\_timeout](#input\_load\_balancer\_delete\_timeout) | Timeout value when deleting the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are application or network. | `string` | `"application"` | no |
| <a name="input_load_balancer_update_timeout"></a> [load\_balancer\_update\_timeout](#input\_load\_balancer\_update\_timeout) | Timeout value when updating the ALB. | `string` | `"10m"` | no |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | To specify a key prefix for aws resource | `string` | `"dso"` | no |
| <a name="input_s3_acl"></a> [s3\_acl](#input\_s3\_acl) | ACL to apply to the S3 bucket | `string` | `"log-delivery-write"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the s3 bucket to export the patch log to | `string` | `"dso"` | no |
| <a name="input_s3_lifecycle_rule"></a> [s3\_lifecycle\_rule](#input\_s3\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | <pre>[<br>  {<br>    "enabled": true,<br>    "expiration": {<br>      "days": 90,<br>      "expired_object_delete_marker": true<br>    },<br>    "filter": {<br>      "prefix": "*"<br>    },<br>    "id": "log-delivery",<br>    "transition": [<br>      {<br>        "days": 30,<br>        "storage_class": "ONEZONE_IA"<br>      },<br>      {<br>        "days": 60,<br>        "storage_class": "GLACIER"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_s3_server_access_logging"></a> [s3\_server\_access\_logging](#input\_s3\_server\_access\_logging) | A settings of bucket logging. { target\_bucket, target\_prefix} | `map(string)` | `{}` | no |
| <a name="input_s3_sse_algorithm"></a> [s3\_sse\_algorithm](#input\_s3\_sse\_algorithm) | The server-side encryption algorithm to use | `string` | `"AES256"` | no |
| <a name="input_security_group_extend_rules"></a> [security\_group\_extend\_rules](#input\_security\_group\_extend\_rules) | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.<br>{<br>  type              = "ingress"<br>  from\_port         = 6379<br>  to\_port           = 6379<br>  protocol          = "tcp"<br>  cidr\_blocks       = []<br>  security\_group\_id = "sg-123456789"<br>} | `list(any)` | `[]` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.<br>  {<br>    type                     = "ingress"<br>    from\_port                = 443<br>    to\_port                  = 443<br>    protocol                 = "tcp"<br>    cidr\_blocks              = ["0.0.0.0/0"]<br>    source\_security\_group\_id = null<br>    self                     = null<br>  }, | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": null,<br>    "source_security_group_id": null,<br>    "to_port": 0,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The security groups to attach to the load balancer. e.g. ["sg-edcd9784","sg-edcd9785"] | `list(string)` | `[]` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | A list of subnet mapping blocks describing subnets to attach to network load balancer | `list(map(string))` | `[]` | no |
| <a name="input_subnet_tag"></a> [subnet\_tag](#input\_subnet\_tag) | Tag Name of subnet to get list of subnets. | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f'] | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id where the load balancer and other resources will be deployed. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_tcp_listener_arns"></a> [http\_tcp\_listener\_arns](#output\_http\_tcp\_listener\_arns) | The ARN of the TCP and HTTP load balancer listeners created. |
| <a name="output_http_tcp_listener_ids"></a> [http\_tcp\_listener\_ids](#output\_http\_tcp\_listener\_ids) | The IDs of the TCP and HTTP load balancer listeners created. |
| <a name="output_https_listener_arns"></a> [https\_listener\_arns](#output\_https\_listener\_arns) | The ARNs of the HTTPS load balancer listeners created. |
| <a name="output_https_listener_ids"></a> [https\_listener\_ids](#output\_https\_listener\_ids) | The IDs of the load balancer listeners created. |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The ID and ARN of the load balancer we created. |
| <a name="output_lb_arn_suffix"></a> [lb\_arn\_suffix](#output\_lb\_arn\_suffix) | ARN suffix of our load balancer - can be used with CloudWatch. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | The ID and ARN of the load balancer we created. |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The zone\_id of the load balancer to assist with creating DNS records. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group |
| <a name="output_target_group_arn_suffixes"></a> [target\_group\_arn\_suffixes](#output\_target\_group\_arn\_suffixes) | ARN suffixes of our target groups - can be used with CloudWatch. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
| <a name="output_target_group_attachments"></a> [target\_group\_attachments](#output\_target\_group\_attachments) | ARNs of the target group attachment IDs. |
| <a name="output_target_group_names"></a> [target\_group\_names](#output\_target\_group\_names) | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. |
