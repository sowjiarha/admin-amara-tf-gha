resource "aws_cloudfront_response_headers_policy" "headers" {
  name = "arha-security-headers-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "SAMEORIGIN"
      override = true
    }
    referrer_policy {
      referrer_policy = "no-referrer"
      override = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains = true
      preload = true
      override = true
    }
  }
}
