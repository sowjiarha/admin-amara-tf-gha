resource "aws_route53_record" "cdn_record" {
  zone_id = "${var.zone_id}"
  name    = "${var.domainName}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.www_distribution.domain_name]
}
