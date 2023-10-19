data "aws_iam_policy_document" "sqs_dlq" {
  statement {
    sid = "SQSDLQAccess"

    actions = ["sqs:SendMessage"]

    resources = [ var.sqs_dlq_arn ]
  }
}

resource "aws_iam_policy" "sqs_dlq" {
  name        = "lambda_sqs_dlq_${var.name}"
  description = "lambda_sqs_dlq_${var.name}"

  path   = "/lambda/${var.name}/"
  policy = data.aws_iam_policy_document.sqs_dlq.json
}

resource "aws_iam_role_policy_attachment" "sqs_dlq" {
  role       = local.role_name
  policy_arn = aws_iam_policy.sqs_dlq.arn
}
