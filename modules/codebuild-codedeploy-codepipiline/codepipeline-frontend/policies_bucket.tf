resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "${var.common.env}-${var.common.project}-pipeline"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
