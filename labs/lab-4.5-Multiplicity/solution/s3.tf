locals {
  application_buckets = {
    uploads = {
      acl        = "private"
      versioning = true
    },
    media = {
      acl        = "private"
      versioning = false
    },
    feeds = {
      acl        = "public-read"
      versioning = true
    }
  }
  archiving_enabled = false
}

resource "aws_s3_bucket" "lab-bucket" {
  for_each = local.application_buckets

  bucket_prefix = "terraform-labs-${each.key}-"
  acl           = each.value.acl

  versioning {
    enabled = each.value.versioning
  }
}

resource "aws_s3_bucket" "archive" {
  count = local.archiving_enabled ? 1 : 0

  bucket_prefix = "terraform-labs-archives-"
  acl           = "private"
}
