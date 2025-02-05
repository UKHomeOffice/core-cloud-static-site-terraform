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
    cloudfront_aliases              = set
    cloudfront_cert                 = string
    cloudfront_function_rewrite_arn = string

    #required for naming of resources
    #e.g. "cc-static-site-${var.tenant_vars.product}-${var.tenant_vars.component}"
    component                       = string
    product                         = string
  })
}

variable "cloud_front_default_vars" {
  type = any
}

variable "aws_region" {
  type = string
}
