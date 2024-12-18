resource "aws_wafv2_web_acl" "default" {
  name        = "cc-static-site-${var.tenant_vars.product}-${var.tenant_vars.component}"
  description = "Static Site WAF rule for ${var.tenant_vars.product} ${var.tenant_vars.component}"
  scope       = "CLOUDFRONT"
  provider    = aws.us-east-1

  tags = local.common_tags

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "static-site-${var.tenant_vars.product}-${var.tenant_vars.component}"
      sampled_requests_enabled   = false
    }
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "static-site-${var.tenant_vars.product}-${var.tenant_vars.component}"
    sampled_requests_enabled   = false
  }


}
