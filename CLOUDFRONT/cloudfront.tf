provider "aws" {
  region     = "us-east-1"
  
}

#s3 bucket

resource "aws_s3_bucket" "mys3bucket" {

bucket = "my-cldf-bucket"
acl    = "public-read"
tags = {
    Name        = "My S3 bucket"
  }

}


#cloud front
resource "aws_cloudfront_distribution" "s3_distribution" {



  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {

    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id =aws_s3_bucket.mys3bucket.id 

    # forwarded_values {
    #   query_string = false
    
    #   cookies {
    #     forward = "none"
    #   }
    # }

    # viewer_protocol_policy ="redirect-to-https" #"allow-all"
    
    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400


    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }


    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
 }
 origin {
    domain_name = aws_s3_bucket.mys3bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.mys3bucket.id
  }


 price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }



  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
}

 # Cloudfront Origin Access Identity
  resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity" {
  comment    = "Only This User is allowed for S3 Read bucket"
 } 
