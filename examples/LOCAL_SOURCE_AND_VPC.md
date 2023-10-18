Example with local source code and VPC connectivity

```ruby
module "lambda_kafka_available_alarm" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-lambda?ref=HEAD"

  name = "kafka test lambda"
  role_arn = null
  role_arn_provided = false
  environment_variables = {
    KAFKA_HOSTS = "172.31.35.62 172.31.15.122 172.31.23.241"
  }

  source_type = "local"
  source_directory_location = "${path.module}/lambda_kafka_available_alarm" # directory in the same directory as this tf code
  source_file_name = null

  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"

  kms_key_arn = module.kms.kms_key_arn # general KMS module
  memory_size = 128
  timeout = 30

  subnet_ids = data.aws_subnets.current.ids
  security_group_ids = [ aws_security_group.lambda_kafka_available_alarm.id ]
}

data "aws_vpc" "current" {
  id = "vpc-fabe5c9f"
}

data "aws_subnets" "current" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }
}

resource "aws_cloudwatch_event_rule" "lambda_kafka_available_alarm_eventbridge_rule" {
  name        = "Periodical_check_for_Kafka_availability"
  description = "Periodical check for Kafka availability"
  is_enabled = true

  schedule_expression = "rate(10 minutes)"
  event_bus_name = "default"
}

resource "aws_cloudwatch_event_target" "mot-job-scheduling-processor_eventbridge_target" {
  rule      = aws_cloudwatch_event_rule.lambda_kafka_available_alarm_eventbridge_rule.name
  event_bus_name = "default"
  target_id = "SendToLambda_lambda_kafka_available_alarm_eventbridge_rule"
  arn       = module.lambda_kafka_available_alarm.lambda_function_arn

  dead_letter_config {
    arn = module.sqs_dlq.sqs_dlq_arn # our sqs_dlq module
  }
}

resource "aws_lambda_permission" "mot-job-scheduling-processor_eventbridge" {
  statement_id  = "EventBridge10MinutesToKafkaAvailableLambda"
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_kafka_available_alarm_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_kafka_available_alarm_eventbridge_rule.arn

  depends_on = [
    module.lambda_kafka_available_alarm
  ]
}

resource "aws_security_group" "lambda_kafka_available_alarm" {
  name = "lambda_kafka_available_alarm"
  vpc_id = data.aws_vpc.current.id
}

# security group rules not demonstrated

```
