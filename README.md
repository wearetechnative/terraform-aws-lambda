# Terraform AWS [lambda] ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

This module implements Lambda functionality in AWS with all known best practices with regards to logging and security.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage

See the [examples](./examples) of some basic scenarios.

The artifact hash is ignored when ECR is used for compatibility with CI/CD setups.

## Future work

The local setup (uploading of .zip) should be replaced by a dedicated S3 bucket because this method is an improvement in every aspect over local uploads.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default_exec_role"></a> [default\_exec\_role](#module\_default\_exec\_role) | git@github.com:TechNative-B-V/terraform-aws-module-iam-role | 81c45f4d87bace3e990e64b92030292ac2fc480c |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sqs_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [archive_file.lambda_source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Architecture for Lambda function can be either `x86_64` or `arm64`. Defaults to x86\_64. | `string` | `"x86_64"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Key value map of environment variables. | `map(string)` | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Entrypoint in the application. Defaults to `index.handler`. | `string` | `"index.handler"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key to use for encrypting RDS instances. | `string` | n/a | yes |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Lambda memory size. Defaults to 128. | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | Prefix name for DynamoDB. Must be unique within the region. | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Exec role for Lambda function. | `string` | `null` | no |
| <a name="input_role_arn_provided"></a> [role\_arn\_provided](#input\_role\_arn\_provided) | Workaround TerraForm limitation. Set to true if var.role\_arn is set, otherwise false. | `bool` | `false` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda runtime which must be set when var.source\_type is s3 or local. | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs if VPC connectivity is required. Requires var.subnet\_ids to be set too. | `list(string)` | `[]` | no |
| <a name="input_source_directory_location"></a> [source\_directory\_location](#input\_source\_directory\_location) | ECR location URL, S3 bucket or directory path depending on the value of var.source\_type. | `string` | n/a | yes |
| <a name="input_source_file_name"></a> [source\_file\_name](#input\_source\_file\_name) | ECR tag, S3 key or null (local) depending on the value of var.source\_type. | `string` | n/a | yes |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | Is set to either ecr, s3 or local. Currently only supports ecr and local. | `string` | `"ecr"` | no |
| <a name="input_sqs_dlq_arn"></a> [sqs\_dlq\_arn](#input\_sqs\_dlq\_arn) | Dead Letter Queue for on\_failure delivery of invocations | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs if VPC connectivity is required. Requires var.security\_group\_ids to be set too. | `list(string)` | `[]` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Lambda timeout. Defaults to 3 seconds. | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | n/a |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | n/a |
<!-- END_TF_DOCS -->
