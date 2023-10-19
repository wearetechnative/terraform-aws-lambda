Example with ECR repository and inflight encrypted parameter.

```ruby
module "lambda_function" {
    source = "git@github.com:TechNative-B-V/terraform-aws-module-lambda?ref=HEAD"

    name = "example_lambda_with_ecr"
    role_arn = module.mot-job-executor_exec_role.role_arn
    role_arn_provided = true
    environment_variables = {
        "API_AUTH_SECRET_KEY": aws_kms_ciphertext.api_auth_secret_key.ciphertext_blob
        "CUSTOMER_API_HOST": "https://www.example.com"
    }
    handler = null # ecr
    source_type = "ecr"

    source_directory_location = "123123123.dkr.ecr.eu-central-1.amazonaws.com/repositoryName"
    source_file_name = "latest"

    kms_key_arn = module.kms_lambda.kms_key_arn # general KMS module
    memory_size = 128
    timeout = 10
}

resource "aws_kms_ciphertext" "api_auth_secret_key" {
  key_id = module.kms.kms_key_arn

  plaintext = data.aws_ssm_parameter.api_auth_secret_key.value
}

data "aws_ssm_parameter" "api_auth_secret_key" {
  name = "/lepaya_stack/api/API_AUTH_SECRET_KEY"
  with_decryption = true
}

module "mot-job-executor_exec_role" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-iam-role?ref=HEAD"

  role_name = "mot-job-executor_exec_role"
  role_path = "/lambda/mot-job-executor/"

  aws_managed_policies = [ "ReadOnlyAccess" ]
  customer_managed_policies = { }

  trust_relationship = {
    "lambda" : { "identifier" : "lambda.amazonaws.com", "identifier_type" : "Service", "enforce_mfa" : false, "enforce_userprincipal" : false, "external_id" : null, "prevent_account_confuseddeputy" : false }
  }
}
```
