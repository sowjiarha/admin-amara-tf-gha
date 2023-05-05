resource "aws_cloudfront_distribution" "www_distribution" {
  depends_on = [aws_s3_bucket.bucket]
  // origin is where CloudFront gets its content from.
  origin {

    // Here we're using our S3 bucket's URL!
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    // This can be any name to identify this origin.
    origin_id   = aws_s3_bucket.bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.arha-dev.id
}

  enabled             = true
  default_root_object = "index.html"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id       = "${var.domainName}"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
   response_headers_policy_id = aws_cloudfront_response_headers_policy.headers.id

  }

  // rather than the domain name CloudFront gives us.
  aliases = ["${var.domainName}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    acm_certificate_arn = "${var.acm_arn}"
    ssl_support_method  = "sni-only"
  }
}
resource "aws_cloudfront_origin_access_control" "arha-dev" {
  name                              = "arha-dev"
  description                       = "arha-dev Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
                                                          
