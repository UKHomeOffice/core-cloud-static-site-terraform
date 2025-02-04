variable "tenant_vars" {
  type = object({
    # enforced tags, all required attributes for costing and ID
    cost_centre                     = string
    account_code                    = string
    portfolio_id                    = string
    project_id                      = string
    service_id                      = string

    # other attributes, required for cloudfront creation
    repository                      = string
    github_environment_name         = string
    cloudfront_aliases              = string
    cloudfront_cert                 = string
    cloudfront_function_rewrite_arn = string
  })
}

variable "cloud_front_default_vars" {
  type = any
}

variable "aws_region" {
  type = string
}
