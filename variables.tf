variable "project" {
  description = "project name"
  default     = "accounting"
}

variable "environment" {
  description = "it's dev"
  default     = "dev"

}

variable "region" {
  description = "locality of the Azure server"
  default     = "East US 2"
}


variable "tags" {
  description = "tags that are always getting copy pasted"
  default = {
    environment = "dev"
    project     = "accounting"
    created_by  = "terraform"
  }

}

variable "password" {
  description = "SQL db password"
  type        = string
  sensitive   = true
}
