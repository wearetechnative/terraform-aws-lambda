locals {
  default_role_name = "lambda_exec_role_${var.name}"
  role_name         = var.role_arn != null ? split("/", var.role_arn)[length(split("/", var.role_arn)) - 1] : local.default_role_name

  # validate input
  vpc_config_enabled = length(var.security_group_ids) > 0 && length(var.subnet_ids) > 0 ? true : false
}
