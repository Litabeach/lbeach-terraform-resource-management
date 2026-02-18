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
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "release" {
  type        = string
}

variable "subscription_id" {
  type      = string
  sensitive = true
}
