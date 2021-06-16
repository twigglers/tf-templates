provider "aws" {
  region = "ap-southeast-2"
  skip_metadata_api_check = true
  skip_requesting_account_id = true
  skip_region_validation = true
  skip_get_ec2_platforms = true
  skip_credentials_validation = true
}