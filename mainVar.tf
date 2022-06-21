variable "location" {
  type        = string
  default     = "eastus2"
  description = "Location where the resoruces are going to be created."
}

variable "suffix" {
  type        = string
  default     = "MZV"
  description = "To be added at the beginning of each resource."
}

variable "tags" {
  type = map(string)
  default = {
    "Environment" = "Dev"
    "Project"     = "DevOps"
    "BillingCode" = "Internal"
  }
  description = "tags to be applied to the resource."
}

variable "rgName" {
  type        = string
  default     = "AllVMsDemoRG"
  description = "Resource Group Name."
}
