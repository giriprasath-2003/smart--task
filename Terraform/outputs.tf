output "s3_bucket_name"{
  value = aws_s3_bucket.s3.bucket
}

output "cloudfront_dist_id"{
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_domain_name"{
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
