output "website_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_distro.id
}

output "route53_zone_id" {
  description = "The ID of the Route53 zone"
  value       = aws_route53_zone.website_domain_zone.zone_id
}