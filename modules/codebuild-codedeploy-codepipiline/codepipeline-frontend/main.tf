resource "aws_cloudwatch_event_rule" "cloudwatch_event" {
  name        = "codepipeline-${var.common.env}-${var.common.project}-${var.name}-rule"
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the Amazon S3 object key or S3 folder. Deleting this may prevent changes from being detected in that pipeline. Read more: http://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-about-starting.html"

  event_pattern = jsonencode({
    "source": [
      "aws.s3"
    ],
    "detail-type": [
      "AWS API Call via CloudTrail"
    ],
    "detail": {
      "eventSource": [
        "s3.amazonaws.com"
      ],
      "eventName": [
        "PutObject",
        "CompleteMultipartUpload",
        "CopyObject"
      ],
      "requestParameters": {
        "bucketName": [
          "${aws_s3_bucket.pipeline_bucket.arn}"
        ],
        "key": [
          "github-webhook/${var.name}.zip"
        ]
      }
    }
  })
}


resource "aws_cloudwatch_event_target" "event_target" {
  target_id = "event_target"
  rule      = aws_cloudwatch_event_rule.cloudwatch_event.name
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = aws_iam_role.event_pipeline.arn
}

# CodePipeline
resource "aws_codestarconnections_connection" "github" {
  name          = "github-codepipeline"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.common.env}-${var.common.project}"
  role_arn = aws_iam_role.role_codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      input_artifacts  = []
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:115228050885:connection/fe363bc1-7206-4c5b-8d8d-c06bec446238"
        FullRepositoryId = var.repo   # Trourest/test_Moon
        BranchName       = var.branch # Default: master
      }
    }
  }

  stage {
    name = "Deploy"
    action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "S3"
        input_artifacts = ["SourceArtifact"]
        version         = "1"
        configuration = {
          # ClusterName = "${var.common.env}-${var.common.project}" # Change
          BucketName =  "test-giang"
          Extract = true
        #   ObjectKey = "index.html"
      }
    }
  }
}

# Webhook rule for codepipeline
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "webhook-github-bar"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name

  authentication_configuration {
    secret_token = ""
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/master"
  }
}
