# stolen from https://github.com/hashicorp/terraform/issues/8344

data "archive_file" "lambda_source" {
  count = var.source_type == "local" ? 1 : 0

  type             = "zip"
  source_dir       = var.source_directory_location
  output_path      = "${path.module}/lambda_function_${var.name}.zip" # include name to prevent overwrite when module is reused
  output_file_mode = "0666"                                           # cross platform consistent output
}
