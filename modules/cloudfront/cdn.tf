################# S3 / CLOUDFRONT #########################

# terraform import -var-file=stg.tfvars module.s3_cdn.aws_s3_bucket.s3_storage stg-madworld-market-storage
resource "aws_s3_bucket" "s3_storage" {
  bucket = "${var.common.env}-${var.common.project}-storage" # Change
}


resource "aws_s3_bucket_accelerate_configuration" "s3_accelerate" {
  bucket = aws_s3_bucket.s3_storage.id
  status = "Enabled"
}
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_web_config_storage" {
  bucket = aws_s3_bucket.s3_storage.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

data "aws_iam_policy_document" "policy_doc_storage" {
  # type = "CanonicalUser"
  # identifiers = ["FeCloudFrontOriginAccessIdentity.S3CanonicalUserId"]
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cf_oai.iam_arn]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_storage.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "policy_storage" {
  bucket = aws_s3_bucket.s3_storage.id
  policy = data.aws_iam_policy_document.policy_doc_storage.json
}


# Create Cloudfront
resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  comment = "${var.common.env}-${var.common.project}-storage"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_storage.bucket_regional_domain_name
    origin_id   = "${var.common.env}-${var.common.project}-storage"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  comment             = "${var.common.env}-${var.common.project}-storage"
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = [var.cdn_domain]
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.common.env}-${var.common.project}-storage"
    compress         = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 60
    default_ttl            = 3600
    max_ttl                = 86400
  }
  viewer_certificate {
    acm_certificate_arn = var.cf_cert_arn
    ssl_support_method  = "sni-only"
  }
  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  depends_on = [aws_s3_bucket.s3_storage]
}

output "cf_distribution_domain_name" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}

output "cf_distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
}

output "cf_distribution_id" {
  value = aws_cloudfront_distribution.cf_distribution.id
}