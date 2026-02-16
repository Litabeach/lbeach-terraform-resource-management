variable "resource_naming_prefix"           { type = string }
variable "restricted_resource_naming_prefix" { type = string }
variable "tags"                             { type = map(string) }


variable "location" {
  type        = string
  default     = "Central US"
}

variable "release" {
  type        = string
  description = "Used for Assignment 3 to demonstrate promotion-by-change"
  default     = "0"
}

