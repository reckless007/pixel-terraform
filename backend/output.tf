output "s3_bucket" {

value = {
"bucket" = aws_s3_bucket.tf-backend-s3.bucket
"arn" = aws_s3_bucket.tf-backend-s3.arn

}

}