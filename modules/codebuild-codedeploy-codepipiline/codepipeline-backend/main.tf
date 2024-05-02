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
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:115228050885:connection/c75d54e8-0709-4254-9b7c-5169da76d769"
        FullRepositoryId = var.repo   # Trourest/test_Moon
        BranchName       = var.branch # Default: master
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      configuration = {
        "ProjectName" = var.codebuild_arn
      }
    }
  }

  stage {
    name = "Deploy"
    action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        input_artifacts = ["BuildArtifact"]
        version         = "1"
        configuration = {
          # ClusterName = "${var.common.env}-${var.common.project}" # Change
          ClusterName =  "${var.cluster_name}" # Change
          FileName = "imagedefinitions.json"
          ServiceName = "${var.common.env}-${var.common.project}-${var.name}"
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

# Add token
  authentication_configuration {
    secret_token = ""
  }



  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/master"
  }
}
