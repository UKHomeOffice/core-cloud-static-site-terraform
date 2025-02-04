

locals {
  common_tags = {
    cost-centre   = var.tenant_vars.cost_centre
    account-code  = var.tenant_vars.account_code
    portfolio-id  = var.tenant_vars.portfolio_id
    project-id    = var.tenant_vars.project_id
    service-id    = var.tenant_vars.service_id
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [ aws.us-east-1 ]
    }
  }
}
