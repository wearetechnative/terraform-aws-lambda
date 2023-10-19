# resource "aws_lambda_provisioned_concurrency_config" "this" {
#   function_name                     = aws_lambda_function.this.function_name
#   provisioned_concurrent_executions = 1 # keep standard for now
#   qualifier                         = aws_lambda_function.this.version
# }

# version (aws_lambda_function.this.version) is incremeted on pipeline run, disable for now
