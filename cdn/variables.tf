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

# Will be prepended to the name associated r53_zone_id
variable "r53_domain_name" {
  default = "cdn"
}
