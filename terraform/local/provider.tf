provider "aws" {
  region = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true

  endpoints {
    s3 = "http://localstack:4566"
    lambda = "http://localstack:4574"
    apigateway = "http://localstack:4567"
  }
}
