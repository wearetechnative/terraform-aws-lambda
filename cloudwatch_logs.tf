resource "aws_cloudwatch_log_group" "cloudwatch_logs" {
  name       = "/aws/lambda/${aws_lambda_function.this.function_name}"
  kms_key_id = var.kms_key_arn

  retention_in_days = 90

}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    sid = "AllowCloudWatchLogs"

    actions = ["logs:PutLogEvents", "logs:CreateLogStream"]

    resources = ["${aws_cloudwatch_log_group.cloudwatch_logs.arn}:*"]
  }

  # not required, works without...
  # statement {
  #   sid = "AllowCloudWatchMetrics"

  #   actions = [ "logs:PutMetricData" ]

  #   resources = [ "*" ]

  #   condition {
  #     test = "StringEquals"
  #     variable = "cloudwatch:namespace"
  #     values = [ "AWS/Lambda" ]
  #   }
  # }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "lambda_cloudwatch_${var.name}"
  description = "lambda_cloudwatch_${var.name}"

  path   = "/lambda/${var.name}/"
  policy = data.aws_iam_policy_document.cloudwatch_logs.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = local.role_name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}
