resource "aws_iam_role" "sfn_exec" {
  name = "sfn_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "eventbridge_exec" {
  name = "eventbridge_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "sfn_execution_policy" {
  name        = "sfn_execution_policy"
  description = "Policy for Step Functions execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "states:StartExecution"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "eventbridge_execution_policy" {
  name        = "eventbridge_execution_policy"
  description = "Policy for EventBridge execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "states:StartExecution"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sfn_basic_execution" {
  role       = aws_iam_role.sfn_exec.name
  policy_arn = aws_iam_policy.sfn_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "eventbridge_sfn_execution" {
  role       = aws_iam_role.eventbridge_exec.name
  policy_arn = aws_iam_policy.eventbridge_execution_policy.arn
}