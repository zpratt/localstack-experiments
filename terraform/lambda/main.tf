data archive_file "hello-world-impl" {
  output_path = var.output_path
  type = "zip"
  source_dir = var.lambda_src_dir
}

resource aws_lambda_function "hello-world" {
  function_name = var.lambda_name
  handler = var.handler
  role = ""
  runtime = var.node_version
  filename = data.archive_file.hello-world-impl.output_path
  source_code_hash = filebase64sha256(data.archive_file.hello-world-impl.output_path)
}

output "invoke_arn" {
  value = aws_lambda_function.hello-world.invoke_arn
}
