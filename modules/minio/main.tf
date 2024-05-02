resource "aws_s3_bucket" "minio" {
  bucket = "${var.common.env}-${var.common.project}-${var.name_minio}"

  tags = {
    Name        = "Minio S3"
    Environment = "Staging"
  }
}

# Build aacelerate for S3
resource "aws_s3_bucket_accelerate_configuration" "example" {
  bucket = aws_s3_bucket.minio.id
  status = "Enabled"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.minio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.minio.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Need s3 bucket policy

# Need s3 notification

# Need s3 objectlocking

# Need s3 logs