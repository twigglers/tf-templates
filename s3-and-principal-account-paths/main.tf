provider "aws" {
  region = "ap-southeast-2"
}

data "aws_caller_identity" "current" {}


# Bucket related resources
locals {
  bucket_name = "principal-account-testing-${data.aws_caller_identity.current.account_id}"
}

data "aws_iam_policy_document" "allow_read" {
  statement {
    sid       = "AccountRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/$${aws:PrincipalAccount}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["o-yyyyyyyyyy"]
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_read" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_read.json
}

# Objects for testing
resource "aws_s3_bucket_object" "member_account_1" {
  key     = "123456789012/test.txt"
  bucket  = aws_s3_bucket.example.id
  content = "important data"
}

resource "aws_s3_bucket_object" "member_account_2" {
  key     = "210987654321/test.txt"
  bucket  = aws_s3_bucket.example.id
  content = "other data"
}