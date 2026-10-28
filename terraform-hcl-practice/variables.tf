variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["prod", "dev", "test"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "allowed_regions" {
  description = "Allowed locations for the lab"
  type        = list(string)
  default     = ["centralindia", "westindia"]
}

variable "environment_tags" {
  description = "Label associated with each environment"
  type        = map(string)

  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}
