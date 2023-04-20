data "aws_iam_policy_document" "elb_logs_bucket_data" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    principals {
      identifiers = data.aws_elb_service_account.elb.*.arn
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}/*",
    ]
    sid = "ELBLogs"
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}",
    ]
  }
}

data "aws_subnets" "selected" {
  filter {
    name = "vpc-id"
    values = [
      var.vpc_id
    ]
  }
  tags = {
    Name = var.subnet_tag
  }
}

data "aws_elb_service_account" "elb" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
