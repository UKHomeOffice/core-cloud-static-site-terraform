variable "tenant_vars" {
  type = object({
    # enforced tags
    cost_centre                     = object({type=string, nullable=false})
    account_code                    = object({type=string, nullable=false})
    portfolio_id                    = object({type=string, nullable=false})
    project_id                      = object({type=string, nullable=false})
    service_id                      = object({type=string, nullable=false})
    # other attributes
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
