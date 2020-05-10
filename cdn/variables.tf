variable "region" {
}

variable "servers_per_az" {
  default = 1
}

variable "instance_type" {
  default = "t3.nano"
}

variable "r53_zone_name" {
  default = "jonathan.camp"
}

variable "r53_domain_name" {
  default = "cdn"
}

variable "blacklisted_az" {
  default = ["us-west-1a", "us-east-1c", "ap-northeast-1a"]
}