terraform {
  # It is recommended to use remote state instead of local
  # You can update these values in order to configure your remote state.
  /*  backend "remote" {
    organization = "{{ORGANIZATION_NAME}}"

    workspaces {
      name = "{{WORKSPACE_NAME}}"
    }
  }
*/
  required_version = "= 1.2.3"
  required_providers {
    azurerm = "=3.10.0"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mainRG" {
  name     = "${var.suffix}${var.rgName}"
  location = var.location

  tags = var.tags
}
