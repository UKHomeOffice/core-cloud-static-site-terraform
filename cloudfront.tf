resource "aws_cloudfront_origin_access_control" "static_site_identity" {
  for_each                          = toset(var.tenant_vars)
  name                              = "cc-static-site-${each.value.product}-${each.value.component}"
  description                       = "Origin access control for ${each.value.product} ${each.value.component}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_site_distribution" {
  for_each                   = toset(var.tenant_vars)
  origin {
    domain_name              = aws_s3_bucket.static_site[each.key].bucket_regional_domain_name
    origin_id                = aws_s3_bucket.static_site[each.key].id
    origin_access_control_id = aws_cloudfront_origin_access_control[each.key].static_site_identity.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront distribution for ${each.value.product} ${each.value.component}"
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = each.value.cloudfront_aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_site[each.key].id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = each.value.cloudfront_function_rewrite_arn
    }

  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/404.html" # Path to your custom error page
    response_code         = 404
    error_caching_min_ttl = 10 # Cache TTL in seconds
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = var.cloud_front_default_vars.cloudfront_price_class

  tags = local.common_tags

  viewer_certificate {
    acm_certificate_arn            = each.value.cloudfront_cert
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = "false"
    ssl_support_method             = "sni-only"
  }
  web_acl_id = aws_wafv2_web_acl.default[each.key].arn
}
