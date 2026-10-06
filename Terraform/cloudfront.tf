resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3.bucket_regional_domain_name
    origin_id                = "S3Origin"
  }

  enabled             = true
  default_root_object = "index.html"

default_cache_behavior {
    target_origin_id = "S3Origin"
    viewer_protocol_policy="redirect-to-https"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]


    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
   }
   
   restrictions{
     geo_restriction{
       restriction_type="none"
     }
   }
    
   viewer_certificate{
     cloudfront_default_certificate=true
   }
 }
