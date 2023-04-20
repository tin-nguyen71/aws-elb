locals {
  s3_bucket_name = format("%s-%s-%s-%s", var.master_prefix, var.s3_bucket_name, data.aws_caller_identity.current.account_id, data.aws_region.current.name)
  enabled_s3     = var.create_elb && var.create_s3 && length(keys(var.access_logs)) == 0 ? true : false
}
module "s3" {
  source                   = "git::https://github.com/tin-nguyen71/aws-s3.git?ref=main"
  s3_bucket_name           = var.s3_bucket_name
  s3_server_access_logging = var.s3_server_access_logging
  s3_acl                   = var.s3_acl
  s3_policy                = data.aws_iam_policy_document.elb_logs_bucket_data.json
  create_s3                = local.enabled_s3
  s3_sse_algorithm         = var.s3_sse_algorithm
  s3_lifecycle_rule        = var.s3_lifecycle_rule
  tags                     = var.tags
  master_prefix            = var.master_prefix
  aws_region               = data.aws_region.current.name
  assume_role              = var.assume_role
}
