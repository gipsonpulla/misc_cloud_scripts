/*
resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-tf-test-bucketgipsonp"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}*/

/*
resource "aws_s3_bucket" "my-bucket" {
    bucket = "gips-my-bucket"
    #acl = private
    versioning {
      enabled = true
    }
}
*/

/*
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
    bucket = aws_s3_bucket.my-bucket.id
    
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm     = "AES256"
            }
        }
}*/


resource "aws_s3_bucket" "terraform_state" {
  bucket = "gips-my-bucket1"
  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
