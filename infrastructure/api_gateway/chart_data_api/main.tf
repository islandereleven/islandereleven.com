resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "chart-data-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"

  integration_uri    = data.aws_lambda_function.existing_lambda.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_data" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /data"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_deployment" "api_deployment" { 
    api_id = aws_apigatewayv2_api.lambda_api.id 
    description = "Initial deployment"
    depends_on = [aws_apigatewayv2_route.get_data]
}

resource "aws_apigatewayv2_stage" "api_stage" {  
  api_id      = aws_apigatewayv2_api.lambda_api.id  
  name        = "prod" # Name your stage (e.g., "dev", "prod")  
  # deployment_id = aws_apigatewayv2_deployment.api_deployment.id  
  
  auto_deploy = true # Optional: Auto-deploy on changes  
}  