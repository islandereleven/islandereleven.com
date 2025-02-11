# # infrastructure/lambda/chart_data_api/main.tf
# module "chart_data_api_lambda" {
#   source              = "../../modules/lambda_function"
#   lambda_role_name    = "chart_data_api_role"
#   lambda_policy_name  = "chart_data_api_policy"
#   lambda_function_name = "chart_data_api"
#   lambda_image_uri    = "path/to/chart_data_api_image.zip"
#   lambda_architectures = ["x86_64"]
#   lambda_timeout      = 10
#   environment_variables = {
#     ENV_VAR_NAME = "value"
#   }
#   lambda_policy_statements = [
#     {
#       Effect = "Allow",
#       Action = [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       Resource = ["arn:aws:logs:*:*:*"]
#     },
#     {
#       Effect = "Allow",
#       Action = [
#         "ecr:GetDownloadUrlForLayer",
#         "ecr:BatchGetImage",
#         "ecr:BatchCheckLayerAvailability"
#       ],
#       Resource = ["*"]
#     },
#     {
#       Effect = "Allow",
#       Action = [
#         "s3:PutObject",
#         "s3:GetObject",
#         "s3:ListBucket"
#       ],
#       Resource = [
#         "arn:aws:s3:::islandereleven-data-lake",
#         "arn:aws:s3:::islandereleven-data-lake/*",
#         "arn:aws:s3:::islandereleven.com",
#         "arn:aws:s3:::islandereleven.com/data/*"
#       ]
#     }
#   ]
# }