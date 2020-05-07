data archive_file "hello-world-impl" {
  output_path = "hello-world.zip"
  type = "zip"
  source_file = "../index.js"
}

resource aws_lambda_function "hello-world" {
  function_name = "hello-world"
  handler = "index.handler"
  role = ""
  runtime = var.node_version
  filename = data.archive_file.hello-world-impl.output_path
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "hello-world-gateway"
}

resource "aws_api_gateway_resource" "lambda_proxy" {
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_method" "proxy_methods" {
  authorization = "NONE"
  http_method = "ANY"
  resource_id = aws_api_gateway_resource.lambda_proxy.id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_integration" "lambda_invoker" {
  http_method = aws_api_gateway_method.proxy_methods.http_method
  resource_id = aws_api_gateway_resource.lambda_proxy.id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  type = "AWS_PROXY"
  integration_http_method = "GET"
  uri = aws_lambda_function.hello-world.invoke_arn
}

resource "aws_api_gateway_deployment" "lambda_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_invoker]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name = var.environment
}

output "endpoint_url" {
  value = aws_api_gateway_deployment.lambda_deployment.invoke_url
}