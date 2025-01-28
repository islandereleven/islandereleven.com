resource "aws_route53_zone" "website_domain_zone" {
  name = var.domain_name
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