data "aws_iam_policy_document" "codebuild" {
  version = "2012-10-17"

  statement {
    actions = [
      "logs:*",
      "ssm:*",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:PutImage",
    ]
    effect    = "Allow"
    resources = ["*"]
  }


  statement {
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetStreamingDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:ListStreamingDistributions",
      "cloudfront:ListDistributions",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:*",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::devops2-dev-codepipeline-bucket",
      "arn:aws:s3:::devops2-dev-codepipeline-bucket/*",
    ]
  }
}
