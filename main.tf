resource "aws_lambda_function" "this" {
  function_name = var.name
  description   = var.name
  role          = length(module.default_exec_role) > 0 ? module.default_exec_role[0].role_arn : var.role_arn

  architectures = [var.architecture]
  # code_signing_config_arn
  # dead_letter_config, obsoleted by on failure destination

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? { "one" : true } : {}

    content {
      variables = var.environment_variables
    }
  }

  ephemeral_storage {
    size = 512
  }

  # file_system_config, for EFS

  handler      = var.handler
  runtime      = var.source_type == "ecr" ? null : var.runtime
  package_type = var.source_type == "ecr" ? "Image" : "Zip"

  filename = var.source_type == "local" ? data.archive_file.lambda_source[0].output_path : null
  # s3_bucket todo, implement
  # s3_key todo, implement
  # s3_object_version todo, implement (use S3 data source)

  source_code_hash = var.source_type == "local" ? data.archive_file.lambda_source[0].output_base64sha256 : null

  # image_config, dont override but configure in container
  image_uri = var.source_type == "ecr" ? "${var.source_directory_location}:${var.source_file_name}" : null

  kms_key_arn = var.kms_key_arn

  layers                         = var.layers
  memory_size                    = var.memory_size
  publish                        = true # always create new version
  reserved_concurrent_executions = var.reserved_concurrent_executions

  timeout = var.timeout

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = local.vpc_config_enabled ? var.subnet_ids : []
    security_group_ids = local.vpc_config_enabled ? var.security_group_ids : []
  }

  lifecycle {
    ignore_changes = [image_uri, package_type]
  }
}

resource "aws_lambda_function_event_invoke_config" "this" {
  function_name = aws_lambda_function.this.function_name

  destination_config {
    on_failure {
      destination = var.sqs_dlq_arn
    }

  }
}
