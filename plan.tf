terraform {
    backend "s3" {
        bucket = "sensu-omnibus-artifacts"
        key    = "terraform/sensu-omnibus"
        region = "us-east-1"
    }
}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region = "${var.region}"
}

locals {
    common_tags = "${map(
    "Name", "Sensu Classic Build Automation"
  )}"
}

resource "aws_security_group" "test_kitchen" {
  description = "test-kitchen instances"
  vpc_id      = "${aws_vpc.main.id}"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "SSH Access"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = "${merge(local.common_tags, 
     map("Name", "Sensu Classic Build Automation (DO NOT DELETE)"))}"
}

resource "aws_subnet" "main" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "10.0.1.0/24"
  tags = "${merge(local.common_tags, map())}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(local.common_tags, map())}"
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = "${merge(local.common_tags, map())}"
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.r.id}"
}

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}
output "security_group_id" {
    value = "${aws_security_group.test_kitchen.id}"
}

output "subnet_id" {
    value = "${aws_subnet.main.id}"
}