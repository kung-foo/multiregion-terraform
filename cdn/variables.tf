variable "region" {}

variable "servers_per_az" {
  default = 1
}

variable "instance_type" {
  default = "t2.nano"
}

variable "r53_zone_id" {
  default = "<change me>"
}

variable "r53_domain_name" {
  default = "change.me.com"
}
