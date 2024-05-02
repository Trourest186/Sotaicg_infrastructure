resource "aws_codebuild_project" "codebuild_project" {
  name                   = "${var.env}-${var.project}-${var.name}"
  service_role           = aws_iam_role.codebuild.arn # Need Change
  concurrent_build_limit = 3

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    privileged_mode = false
    type            = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = var.env_var
      content {
        name  = environment_variable.value["key"]
        value = environment_variable.value["value"]
      }
    }
  }
  # vpc_config {
  #   vpc_id = var.network.vpc_id
  #   subnets = var.network.subnet_ids
  #   security_group_ids = [
  #     var.network.sg_container
  #   ]
  # }

  # Using for only Codebuild
  # artifacts {
  #   type = "NO_ARTIFACTS"
  # }

  artifacts {
    type = "CODEPIPELINE"
  }
  # Using for codepipeline
  # source {
  #   type            = "GITHUB"
  #   location        = "https://github.com/${var.account}/${var.repo}.git"
  #   git_clone_depth = 1

  #   git_submodules_config {
  #     fetch_submodules = true
  #   }
  # }
  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  # source_version = var.branch

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.this.name
      status     = "ENABLED"
    }
  }
}

# resource "aws_codebuild_webhook" "codebuild_webhook" {
#   project_name = aws_codebuild_project.codebuild_project.name
#   build_type   = "BUILD"
#   filter_group {
#     filter {
#       type    = "EVENT"
#       pattern = "PUSH"
#     }

#     filter {
#       type    = "HEAD_REF"
#       pattern = "^refs/heads/master$"
#     }
#   }
# }


# Create cloudwatch
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/codebuild/${var.env}-${var.project}-${var.name}"

  retention_in_days = 30
}

################################################################################
# IAM Role for CodeBuild
################################################################################

# Need to change least privilege
resource "aws_iam_role" "codebuild" {
  name = "${var.env}-${var.project}-${var.name}-codebuild"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "codebuild" {
#   role       = aws_iam_role.codebuild.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }
resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_iam_policy" "codepipeline" {
  name   = "codepipeline"
  policy = data.aws_iam_policy_document.codebuild.json
}

output "id_codebuild" {
  value = aws_codebuild_project.codebuild_project.id
}

output "arn_codebuild" {
  value = aws_codebuild_project.codebuild_project.arn
}
