#S3

resource "aws_s3_bucket" "s3" {
  bucket = "devops-workflow-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
