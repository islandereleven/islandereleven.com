# modules/lambda_function/main.tf
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = var.lambda_policy_name
  role   = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = var.lambda_policy_statements
  })
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = var.lambda_image_uri
  architectures = var.lambda_architectures
  timeout       = var.lambda_timeout

  environment {
    variables = var.environment_variables
  }
}