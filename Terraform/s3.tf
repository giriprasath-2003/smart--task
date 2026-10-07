provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  default = "frontend-giri"
}

resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

}
