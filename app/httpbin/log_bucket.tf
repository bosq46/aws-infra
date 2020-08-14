resource "aws_s3_bucket" "alb_log" {
  bucket        = var.log_bucket_name
  force_destroy = true # 中身はあっても削除可能

  # 180 日で自動削除
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
  tags = {
    Name = local.tag
    Env  = var.env
  }
}

# Bucket Policy
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_elb_service_account" "alb_log" {}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.alb_log.id,
      ]
    }
  }
}
