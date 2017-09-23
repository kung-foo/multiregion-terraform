terraform {
  required_version = ">= 0.10.3"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "default" {
  zone_id = "${var.r53_zone_id}"
}

data "aws_ami" "default" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2016.09*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_vpc" "main" {
  cidr_block                       = "192.168.0.0/16"
  assign_generated_ipv6_cidr_block = "true"
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"

  tags {
    Name = "cdn-${var.region}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "cdn-${var.region}-igw"
  }
}

resource "aws_subnet" "public" {
  count                           = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    Name = "cdn-${element(data.aws_availability_zones.available.names, count.index)}-public"
  }
}

resource "aws_route_table" "public" {
  count  = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmpv6"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "server" {
  count                  = "${length(data.aws_availability_zones.available.names) * var.servers_per_az}"
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.default.id}"
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
  ipv6_address_count     = "1"
  vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_vpc.main.default_security_group_id}"]

  tags = {
    Name = "cdn-server-${element(data.aws_availability_zones.available.names, count.index)}-${count.index}"
  }
}

resource "aws_route53_record" "cdnv4" {
  zone_id        = "${data.aws_route53_zone.default.zone_id}"
  name           = "${format("%s.%s", var.r53_domain_name, data.aws_route53_zone.default.name)}"
  type           = "A"
  ttl            = "60"
  records        = ["${aws_instance.server.*.public_ip}"]
  set_identifier = "cdn-${var.region}-v4"

  latency_routing_policy {
    region = "${var.region}"
  }
}

resource "aws_route53_record" "cdnv6" {
  zone_id        = "${data.aws_route53_zone.default.zone_id}"
  name           = "${format("%s.%s", var.r53_domain_name, data.aws_route53_zone.default.name)}"
  type           = "AAAA"
  ttl            = "60"
  records        = ["${flatten(aws_instance.server.*.ipv6_addresses)}"]
  set_identifier = "cdn-${var.region}-v6"

  latency_routing_policy {
    region = "${var.region}"
  }
}
