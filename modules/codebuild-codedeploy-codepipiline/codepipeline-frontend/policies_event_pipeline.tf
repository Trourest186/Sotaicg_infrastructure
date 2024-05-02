######################### Role for CloudwatchEvent #########################
resource "aws_iam_role" "event_pipeline" {
  name = "${var.common.env}-${var.common.project}-event-pipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "event_pipeline" {
  role = aws_iam_role.event_pipeline.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Resource = [
          "arn:aws:codepipeline:${var.common.region}:${var.common.account_id}:${var.common.env}-${var.common.project}-*",
          "arn:aws:codebuild:${var.common.region}:${var.common.account_id}:project/${var.common.env}-${var.common.project}-*"
        ],
        Action = [
          "codepipeline:StartPipelineExecution",
          "codebuild:StartBuild"
        ]
      }
    ]
  })
}