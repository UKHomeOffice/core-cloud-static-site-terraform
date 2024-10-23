

locals {
  common_tags = {
    COST_CENTRE = var.tenant_vars.COST_CENTRE
    PRODUCT     = var.tenant_vars.product
    COMPONENT   = var.tenant_vars.component
  }
}

required_providers {
  aws.us-east-1 = {
    source = "hashicorp/aws"
  }
}
