resource "aws_s3_bucket" "bucket" {
  // Our bucket's name is going to be the same as our site's domain name
  bucket = "${var.bucketName}"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
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
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.www_distribution.arn]
  }
}
}
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

/*resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read-write"
}*/
"s3.tf" 70L, 1781B                                                        19,5          Top
