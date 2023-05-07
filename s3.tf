resource "aws_s3_bucket" "bucket" {
  // Our bucket's name is going to be the same as our site's domain name
  bucket = "${var.bucketName}"
  acl = "private"
}

/*resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}",
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variables = {
        "aws:Referer": "https://${aws_cloudfront_distribution.www_distribution.domain_name}"
      }
      #variable = "AWS:SourceArn"
      #values   = [aws_cloudfront_distribution.www_distribution.arn]
  }
}
}*/
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}


resource "aws_s3_bucket_website_configuration" "website_conf" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
     }
  error_document {
    key = "error.html"
  }
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "s3-my-webapp.example.com"
 }
resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  //ignore_public_acls      = true
  //restrict_public_buckets = true
}                                     
