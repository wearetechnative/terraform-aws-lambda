module "default_exec_role" {
  count = !var.role_arn_provided ? 1 : 0

  source = "git@github.com:wearetechnative/terraform-aws-iam-role?ref=0fe916c27097706237692122e09f323f55e8237e"

  role_name = local.role_name
  role_path = "/lambda/${local.role_name}/"

  aws_managed_policies      = []
  customer_managed_policies = {}

  trust_relationship = {
    "lambda" : { "identifier" : "lambda.amazonaws.com", "identifier_type" : "Service", "enforce_mfa" : false, "enforce_userprincipal" : false, "external_id" : null, "prevent_account_confuseddeputy" : false }
  }
}
