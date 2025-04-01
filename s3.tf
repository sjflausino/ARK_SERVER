resource "aws_s3_bucket" "ark_backup" {
  bucket = var.s3_bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = "ARK Server Backup"
  }
}

