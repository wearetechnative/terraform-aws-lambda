variable "name" {
  description = "Prefix name for DynamoDB. Must be unique within the region."
  type        = string
}

variable "role_arn" {
  description = "Exec role for Lambda function."
  type        = string
  default     = null
}

variable "role_arn_provided" {
  description = "Workaround TerraForm limitation. Set to true if var.role_arn is set, otherwise false."
  type        = bool
  default     = false
}

variable "architecture" {
  description = "Architecture for Lambda function can be either `x86_64` or `arm64`. Defaults to x86_64."
  type        = string
  default     = "x86_64"
}

variable "environment_variables" {
  description = "Key value map of environment variables."
  type        = map(string)
  default     = {}
}

variable "handler" {
  description = "Entrypoint in the application. Defaults to `index.handler`."
  type        = string
  default     = "index.handler"
}

variable "source_type" {
  description = "Is set to either ecr, s3 or local. Currently only supports ecr and local."
  type        = string
  default     = "ecr"
}

variable "source_directory_location" {
  description = "ECR location URL, S3 bucket or directory path depending on the value of var.source_type."
  type        = string
}

variable "source_file_name" {
  description = "ECR tag, S3 key or null (local) depending on the value of var.source_type."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key to use for encrypting RDS instances."
  type        = string
}

variable "memory_size" {
  description = "Lambda memory size. Defaults to 128."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Lambda timeout. Defaults to 3 seconds."
  type        = number
  default     = 3
}

variable "runtime" {
  description = "Lambda runtime which must be set when var.source_type is s3 or local."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs if VPC connectivity is required. Requires var.security_group_ids to be set too."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs if VPC connectivity is required. Requires var.subnet_ids to be set too."
  type        = list(string)
  default     = []
}

variable "sqs_dlq_arn" {
  description = "Dead Letter Queue for on_failure delivery of invocations"
  type        = string
}

variable "layers" {
  description = "A list of Lambda Layer ARNS to be attached to the Lambda."
  type        = list(string)
  default     = []
}
