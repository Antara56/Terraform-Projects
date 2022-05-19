resource "aws_s3_bucket" "storage" {
  bucket = "my-mini-store-bucket"
  acl    = "private"

  tags = {
    Name        = "My S3 bucket"
  }
}