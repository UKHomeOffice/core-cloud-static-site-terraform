

locals {
  common_tags = {
    COST_CENTRE = var.tenant_vars.COST_CENTRE
    PRODUCT     = var.tenant_vars.product
    COMPONENT   = var.tenant_vars.component
  }
}

required_providers {
  aws = {
    source = "hashicorp/aws"
    configuration_aliases = [ aws.us-east-1 ]
  }
}
