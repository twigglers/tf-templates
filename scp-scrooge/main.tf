provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "whitelisting_services" {
  statement {
    sid       = "AllowedServices"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:*",
      "iam:*",
      "s3:*"
    ]
  }
}

resource "aws_organizations_policy" "example" {
  name    = "example"
  content = replace(data.aws_iam_policy_document.whitelisting_services.json, " ", "")
}