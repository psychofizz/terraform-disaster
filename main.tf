provider "azurerm" {
  subscription_id            = "d4a8da62-d65b-4a7a-9ae4-800fb5384ce1"
  skip_provider_registration = "true"
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.region
  tags = {
  }
}
