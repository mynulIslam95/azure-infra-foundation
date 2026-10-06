variable "location" {
  type    = string
  default = "germanywestcentral"
}

variable "prefix" {
  type    = string
  default = "nf"
}

variable "address_space" {
  type    = list(string)
  default = ["10.40.0.0/16"]
}

variable "subnet_prefix" {
  type    = string
  default = "10.40.1.0/24"
}

variable "allowed_management_cidr" {
  type        = string
  default     = "10.20.0.0/24"
  description = "Office network. Do not set 0.0.0.0/0 for SSH."
}

variable "tags" {
  type = map(string)
  default = {
    project = "northfield"
    env     = "lab"
  }
}
