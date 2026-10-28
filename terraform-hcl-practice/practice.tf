locals {
  region        = "centralIndia"
  resource_name = "${var.environment}-${local.region}-web"

  environment_label = var.environment_tags[var.environment]
  is_production     = var.environment == "prod"
  instance_size     = var.environment == "prod" ? "large" : "small"
}
