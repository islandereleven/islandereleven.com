resource "aws_s3_bucket" "data_lake" {
  bucket = var.bucket_name
}
/*
resource "aws_s3_bucket_acl" "data_lake_acl" {
  bucket = aws_s3_bucket.data_lake.id
  acl    = "private"
}*/
/*
resource "aws_s3_bucket_policy" "data_lake_bucket_policy" {
  bucket = aws_s3_bucket.data_lake.id
  policy = templatefile("s3-policy.json", {
    bucket = var.bucket_name,
    account_id = data.aws_caller_identity.current.account_id,
    lambda_role = var.lambda_role
  })
} */