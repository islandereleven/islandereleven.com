provider "aws" {
  alias  = "main"
  region = "eu-central-1"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

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

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }
  
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = templatefile("s3-policy.json", { bucket = var.bucket_name })
}

resource "aws_route53_zone" "website_domain_zone" {
  name = var.domain_name
}

# resource "aws_route53_record" "website_domain_record" {
#   zone_id = aws_route53_zone.website_domain_zone.zone_id
#   name    = var.domain_name
#   type    = "A"
#   alias {
#     name                   = "s3-website.eu-central-1.amazonaws.com"
#     zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
#     evaluate_target_health = false
#   }
# }



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


data "aws_acm_certificate" "cert" {
  domain   = "islandereleven.com"
  statuses = ["ISSUED"]
  provider = aws.virginia
}

resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  comment = "Example OAI"
}

resource "aws_cloudfront_distribution" "cf_distro" {
  provider = aws.virginia
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "website_domain_record" {
  zone_id = aws_route53_zone.website_domain_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distro.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distro.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cf_record" {
  zone_id = aws_route53_zone.website_domain_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distro.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distro.hosted_zone_id
    evaluate_target_health = false
  }
}