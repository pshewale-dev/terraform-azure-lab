locals {
  region        = "centralIndia"
  resource_name = "${var.environment}-${local.region}-web"

  environment_label = var.environment_tags[var.environment]
  is_production     = var.environment == "prod"
  instance_size     = var.environment == "prod" ? "large" : "small"
  is_india_production = (
    var.environment == "prod" &&
    lower(local.region) == "centralindia"
  )

  is_prod_or_dev = (
    var.environment == "prod" ||
    var.environment == "dev"
  )
  is_non_production = !local.is_production
  is_allowed_deployment = (
    local.is_prod_or_dev &&
    !local.is_production
  )
}
