data "aws_subnet" "vpc" {
  for_each = { for v in var.subnet_ids : v => v }

  id = each.key
}

data "aws_security_group" "vpc" {
  for_each = { for v in var.security_group_ids : v => v }

  id = each.value
}

data "aws_iam_policy_document" "vpc" {
  statement {
    sid = "CreateNetworkInterface"

    actions = ["ec2:CreateNetworkInterface"]

    resources = concat([for k, v in data.aws_subnet.vpc : v.arn]
      , [for k, v in data.aws_security_group.vpc : v.arn]
      , [join(":", ["arn", data.aws_partition.current.partition, "ec2", data.aws_region.current.name, data.aws_caller_identity.current.account_id, "network-interface/*"])]
    )
  }

  statement {
    sid = "DescribeNetworkInterfaces"

    actions = ["ec2:DescribeNetworkInterfaces"]

    resources = ["*"]
  }

  statement {
    sid = "DeleteNetworkInterface"

    actions = ["ec2:DeleteNetworkInterface"]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "vpc" {
  count = local.vpc_config_enabled ? 1 : 0

  name        = "lambda_vpc_${var.name}"
  description = "lambda_vpc_${var.name}"

  path   = "/lambda/${var.name}/"
  policy = data.aws_iam_policy_document.vpc.json
}

resource "aws_iam_role_policy_attachment" "vpc" {
  count = length(aws_iam_policy.vpc)

  role       = local.role_name
  policy_arn = aws_iam_policy.vpc[0].arn
}
