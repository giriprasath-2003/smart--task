provider "aws" {
  region = "us-east-1"
}

variable "bucket name" {
  default = "frontend-giri"
}

resource "aws_s3_bucket" "s3" {
  bucket = "frontend-giri"

}
