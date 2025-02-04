/*resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.bucket_name}-data"
}

resource "aws_s3_bucket_public_access_block" "data_bucket_public_access" {
  bucket = aws_s3_bucket.data_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = templatefile("s3-policy.json", { bucket = aws_s3_bucket.data_bucket.id })
}*/