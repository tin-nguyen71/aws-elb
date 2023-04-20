################################################################################
# Load Balancer Variables
################################################################################
variable "create_elb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
  validation {
    condition     = contains([true, false], var.create_elb)
    error_message = "Valid values for var: create_elb are `true`, `false`."
  }
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
  validation {
    condition     = contains([true, false], var.drop_invalid_header_fields)
    error_message = "Valid values for var: drop_invalid_header_fields are `true`, `false`."
  }
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
  validation {
    condition     = contains([true, false], var.enable_deletion_protection)
    error_message = "Valid values for var: enable_deletion_protection are `true`, `false`."
  }
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
  validation {
    condition     = contains([true, false], var.enable_http2)
    error_message = "Valid values for var: enable_http2 are `true`, `false`."
  }
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
  validation {
    condition     = contains([true, false], var.enable_cross_zone_load_balancing)
    error_message = "Valid values for var: enable_cross_zone_load_balancing are `true`, `false`."
  }
}

variable "extra_ssl_certs" {
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward)."
  type        = list(map(string))
  default     = []
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  type        = any
  default     = []
}

variable "https_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "http_tcp_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, http_tcp_listener_index (default to http_tcp_listeners[count.index])"
  type        = any
  default     = []
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "Valid values for var: ip_address_type are `ipv4`, `dualstack`."
  }
}

variable "listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
  validation {
    condition     = contains([true, false], var.internal)
    error_message = "Valid values for var: internal are `true`, `false`."
  }
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "10m"
}

variable "elb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = null
  validation {
    condition     = length(var.elb_name) > 0
    error_message = "Valid values for var: elb_name cannot be an empty string."
  }
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
  validation {
    condition     = contains(["application", "network"], var.load_balancer_type)
    error_message = "Valid values for var: load_balancer_type are `application`, `network`."
  }
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "10m"
}

variable "access_logs" {
  description = "Map containing access logging configuration for load balancer."
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = list(string)
  default     = null
}

variable "subnet_mapping" {
  description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
  type        = list(map(string))
  default     = []
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "enable_waf_fail_open" {
  description = "Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF"
  type        = bool
  default     = false
  validation {
    condition     = contains([true, false], var.enable_waf_fail_open)
    error_message = "Valid values for var: enable_waf_fail_open are `true`, `false`."
  }
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  type        = string
  default     = "defensive"
  validation {
    condition     = contains(["defensive", "monitor", "strictest"], var.desync_mitigation_mode)
    error_message = "Valid values for var: desync_mitigation_mode are `defensive`, `monitor`, `strictest`."
  }
}

variable "security_groups" {
  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
  type        = list(string)
  default     = []
}

################################################################################
# Security Variables
################################################################################

variable "create_security_group" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to create Security Group."
  validation {
    condition     = contains([true, false], var.create_security_group)
    error_message = "Valid values for var: create_security_group are `true`, `false`."
  }
}

variable "security_group_rules" {
  type = list(any)
  default = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      self                     = null
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.
      {
        type                     = "ingress"
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        cidr_blocks              = ["0.0.0.0/0"]
        source_security_group_id = null
        self                     = null
      },
  EOT
}

variable "security_group_extend_rules" {
  type        = list(any)
  default     = []
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.
    {
      type              = "ingress"
      from_port         = 6379
      to_port           = 6379
      protocol          = "tcp"
      cidr_blocks       = []
      security_group_id = "sg-123456789"
    }
  EOT
}

################################################################################
# S3 Variables
################################################################################

variable "create_s3" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether to create S3 bucket"
  validation {
    condition     = contains([true, false], var.create_s3)
    error_message = "Valid values for var: create_s3 are `true`, `false`."
  }
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the s3 bucket to export the patch log to"
  default     = "dso"
  validation {
    condition     = length(var.s3_bucket_name) > 0
    error_message = "Valid values for var: s3_bucket_name cannot be an empty string."
  }
}

variable "s3_sse_algorithm" {
  type        = string
  description = "The server-side encryption algorithm to use"
  default     = "AES256"
}

variable "s3_server_access_logging" {
  type        = map(string)
  default     = {}
  description = "A settings of bucket logging. { target_bucket, target_prefix}"
}

variable "s3_acl" {
  type        = string
  default     = "log-delivery-write"
  description = "ACL to apply to the S3 bucket"
}

variable "s3_lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default = [
    {
      id      = "log-delivery"
      enabled = true
      filter = {
        prefix = "*"
      }
      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days                         = 90
        expired_object_delete_marker = true
      }
    }
  ]
}

################################################################################
# Route 53 Variables
################################################################################

variable "create_dns" {
  default     = false
  type        = bool
  description = "A boolean flag to add record to route53"
  validation {
    condition     = contains([true, false], var.create_dns)
    error_message = "Valid values for var: create_dns are `true`, `false`."
  }
}

variable "dns_zone_id" {
  type        = string
  description = "Route53 parent zone ID."
  default     = null
}

################################################################################
# Common Variables
################################################################################

variable "master_prefix" {
  description = "To specify a key prefix for aws resource"
  type        = string
  default     = "dso"
  validation {
    condition     = length(var.master_prefix) > 0
    error_message = "Valid values for var: master_prefix cannot be an empty string."
  }
}

variable "subnet_tag" {
  description = "Tag Name of subnet to get list of subnets."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS Region name to deploy resources."
  type        = string
  default     = "ap-southeast-1"
}

variable "assume_role" {
  description = "AssumeRole to manage the resources within account that owns"
  type        = string
  default     = null
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.assume_role))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}
