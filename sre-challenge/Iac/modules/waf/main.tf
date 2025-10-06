resource "aws_wafv2_web_acl" "this" {
  name        = "sre-challenge-waf"
  description = "WAF for the sre-challenge ALB"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "sre-challenge-waf"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "sre-challenge-waf-common-rules"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_shield_protection" "this" {
  name         = "sre-challenge-shield-protection"
  resource_arn = aws_wafv2_web_acl.this.arn
}