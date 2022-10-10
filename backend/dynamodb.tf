resource "aws_dynamodb_table" "tf-backend-dynamodb" {
  #name         = "signiance-test"
  #name = "tf-state"
  name = var.dynamodb_name
  billing_mode = "PROVISIONED"

  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  stream_enabled = false
  table_class    = "STANDARD"
  tags = {
    "Name" = "tf-state-lock"
  }
  tags_all = {
    "Name" = "tf-state-lock"
  }

  point_in_time_recovery {
    enabled = false
  }

  timeouts {}

  ttl {
    attribute_name = ""
    enabled        = false
  }


  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

}