# Create ALC WAF for ALB
resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "alb-waf"
  description = "Managed rule WAF"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 0

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#           action_to_use {
#             allow {}
#           }
#           name = "SizeRestrictions_BODY"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesAmazonIpReputationList"
#     priority = 1

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAmazonIpReputationList"
#         vendor_name = "AWS"
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
#       sampled_requests_enabled   = true
#     }
#   }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ALBWafMetrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_config" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.alb_waf.arn

  depends_on = [aws_wafv2_web_acl.alb_waf]

  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb_prod" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}


# IAM for WAF to push logs to Logs Group
resource "aws_iam_role" "waf_logging" {
  name = "waf_logging"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "waf.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "waf_logging" {
  name = "waf_logging"
  role = aws_iam_role.waf_logging.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Log group for WAF
resource "aws_cloudwatch_log_group" "waf_logs" {
  name = "aws-waf-logs-alb-gateway"
}