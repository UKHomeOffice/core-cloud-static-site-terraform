resource "aws_kms_key" "static_site_kms" {
  for_each            = toset(var.tenant_vars)
  enable_key_rotation = true
  tags                = local.common_tags
}


resource "aws_kms_key_policy" "static_site_kms_policy" {
  for_each = toset(var.tenant_vars)
  key_id   = aws_kms_key.static_site_kms.id
  policy   = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "static_site_kms_policy",
    "Statement" : [
      {
        "Sid" : "EnableIAMUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "CloudFrontServiceKmsPolicyKey",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : aws_cloudfront_distribution.static_site_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "static_site_kms_alias" {
  for_each      = toset(var.tenant_vars)
  name          = "alias/static_site/${aws_s3_bucket.static_site[each.key].id}"
  target_key_id = aws_kms_key.static_site_kms[each.key].key_id
}
