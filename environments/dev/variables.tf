variable "lifespan" {
  type    = string
  default = "temp"
}

variable "owner" {
  type    = string
  default = "lbeach"
}

variable "assignment" {
  type    = string
  default = "asg2"
}

variable "environment" {
  type        = string
  description = "The environment (e.g., dev or test)"
  default     = "dev"
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "release" {
  type        = string
  description = "Used for Assignment 3 to demonstrate promotion-by-change"
  default     = "0"
}

variable "subscription_id" {
  type      = string
  sensitive = true
}
