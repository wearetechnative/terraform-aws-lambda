module "default_exec_role" {
  count = !var.role_arn_provided ? 1 : 0

  source = "git@github.com:wearetechnative/terraform-aws-iam-role?ref=9a975f62956b6c4f2593c169d06d1cfe8aad36be"

  role_name = local.role_name
  role_path = "/lambda/${local.role_name}/"

  aws_managed_policies      = []
  customer_managed_policies = {}

  trust_relationship = {
    "lambda" : { "identifier" : "lambda.amazonaws.com", "identifier_type" : "Service", "enforce_mfa" : false, "enforce_userprincipal" : false, "external_id" : null, "prevent_account_confuseddeputy" : false }
  }
}
