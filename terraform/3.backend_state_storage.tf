resource "aws_s3_bucket" "terraform-remote-state-storage-s3-j67698" {
    bucket = "terraform-remote-state-storage-s3-j67698"

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_dynamodb_table" "terraform_state" {
  name = "terraform_state"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
