resource "aws_api_gateway_resource" "lambda_proxy" {
  parent_id = var.gateway.root_resource_id
  path_part = var.path
  rest_api_id = var.gateway.id
}

resource "aws_api_gateway_method" "proxy_methods" {
  authorization = var.authorization
  http_method = var.http_method
  resource_id = aws_api_gateway_resource.lambda_proxy.id
  rest_api_id = var.gateway.id
}

resource "aws_api_gateway_integration" "lambda_invoker" {
  http_method = aws_api_gateway_method.proxy_methods.http_method
  resource_id = aws_api_gateway_resource.lambda_proxy.id
  rest_api_id = var.gateway.id
  type = "AWS_PROXY"
  integration_http_method = var.http_method
  uri = var.lambda.invoke_arn
  timeout_milliseconds = var.timeout
  //  request_templates = {
  //    "application/json" = <<EOF
  //
  //EOF
  //  }
}

resource "aws_api_gateway_deployment" "lambda_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_invoker]

  rest_api_id = var.gateway.id
  stage_name = var.environment
}

output "endpoint_url" {
  value = aws_api_gateway_deployment.lambda_deployment.invoke_url
}