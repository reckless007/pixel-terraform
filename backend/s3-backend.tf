resource "aws_s3_bucket" "tf-backend-s3" {
  bucket = var.bucket
  tags           = {
    Description = "${var.company} Production Terraform state"
    Name = "${var.company}-${var.env}"
    Terraform = true
    }
}
resource "aws_s3_bucket_acl" "tf-backend-acl" {
  bucket = aws_s3_bucket.tf-backend-s3.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf-backend-version" {
  bucket = aws_s3_bucket.tf-backend-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf-backend-encrypt" {
  bucket = aws_s3_bucket.tf-backend-s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
