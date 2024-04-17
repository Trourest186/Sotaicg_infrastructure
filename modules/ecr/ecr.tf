/*
 * ecr.tf
 * Creates a Amazon Elastic Container Registry (ECR) for the application
 * https://aws.amazon.com/ecr/
 */

# # The tag mutability setting for the repository (defaults to IMMUTABLE)
# variable "image_tag_mutability" {
#   type        = string
#   default     = "IMMUTABLE"
#   description = "The tag mutability setting for the repository (defaults to IMMUTABLE)"
# }

###
# ECR image registry 
##
resource "aws_ecr_repository" "ecr_base" {
  name = "${var.common.env}-${var.common.project}-base"
}

# data "aws_caller_identity" "current" {
# }

# # grant access to saml users
# resource "aws_ecr_repository_policy" "app" {
#   repository = aws_ecr_repository.app.name
#   policy     = data.aws_iam_policy_document.ecr.json
# }

# data "aws_iam_policy_document" "ecr" {
#   statement {
#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:DescribeRepositories",
#       "ecr:GetRepositoryPolicy",
#       "ecr:ListImages",
#       "ecr:DescribeImages",
#       "ecr:DeleteRepository",
#       "ecr:BatchDeleteImage",
#       "ecr:SetRepositoryPolicy",
#       "ecr:DeleteRepositoryPolicy",
#       "ecr:GetLifecyclePolicy",
#       "ecr:PutLifecyclePolicy",
#       "ecr:DeleteLifecyclePolicy",
#       "ecr:GetLifecyclePolicyPreview",
#       "ecr:StartLifecyclePolicyPreview",
#     ]

#     principals {
#       type = "AWS"

#       # Add the saml roles for every member on the "team"
#       identifiers = [
#         "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${var.saml_role}/me@example.com",
#       ]
#     }
#   }
# }