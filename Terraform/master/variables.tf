variable "resource_group_location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name_master" {
  type    = string
  default = "module5_master"
}

variable "resource_group_name_k8s" {
  type    = string
  default = "module5_k8s"
}

variable "username" {
  type    = string
  default = "noveed"
}