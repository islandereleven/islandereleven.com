
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "islander_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = templatefile("s3-policy.json", { bucket = var.bucket_name })
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [
      "https://${var.domain_name}",  
      "https://${aws_cloudfront_distribution.cf_distro.domain_name}" ,
      "https://corsproxy.io"
    ] 
    max_age_seconds = 3000
  }
}

resource "aws_s3_object" "pic" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "lemon-press.jpg"                    
  source = "./frontend/lemon-press.jpg"          
  etag   = filemd5("./frontend/lemon-press.jpg") 
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "./frontend/index.html"          
  etag   = filemd5("./frontend/index.html") 
  content_type = "text/html"
}

resource "aws_s3_object" "privacy-policy" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "privacy-policy.html"
  source = "./frontend/privacy-policy.html"          
  etag   = filemd5("./frontend/privacy-policy.html") 
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "style.css"
  source = "./frontend/style.css"          
  etag   = filemd5("./frontend/style.css") 
  content_type = "text/css"
}

resource "aws_s3_object" "sitemap" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "sitemap.xml"
  source = "./frontend/sitemap.xml"          
  etag   = filemd5("./frontend/sitemap.xml") 
  content_type = "application/xml"
}