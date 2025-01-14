module "default_exec_role" {
  count = !var.role_arn_provided ? 1 : 0

  source = "github.com/wearetechnative/terraform-aws-iam-role?ref=9229bbd0280807cbc49f194ff6d2741265dc108a"

  role_name = local.role_name
  role_path = "/lambda/${local.role_name}/"

  aws_managed_policies      = []
  customer_managed_policies = {}

  trust_relationship = {
    "lambda" : { "identifier" : "lambda.amazonaws.com", "identifier_type" : "Service", "enforce_mfa" : false, "enforce_userprincipal" : false, "external_id" : null, "prevent_account_confuseddeputy" : false }
  }
}
