variable "environment" {}
variable "authorization" {}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "hello-world-gateway"
}

module "hello_world_lambda" {
  source = "../lambda"

  environment = var.environment
  lambda_src_dir = "../../src"
  output_path = "../hello-world.zip"
  lambda_name = "hello-world"
  handler = "index.handler"
}

module "hello_world_route" {
  source = "../gateway-route"

  environment = var.environment
  lambda = module.hello_world_lambda
  gateway = aws_api_gateway_rest_api.api_gateway
  path = "{proxy+}"
  http_method = "GET"
  timeout = 5000
  authorization = var.authorization
}
