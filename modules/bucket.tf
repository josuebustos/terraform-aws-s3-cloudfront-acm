resource "aws_s3_bucket" "my_site_bucket" {
  bucket        = var.domainName
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Environment = var.SiteTags
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my_site_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "allow-s3-bucket-access"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_site_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

data "aws_caller_identity" "current" {
}


resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.my_site_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
