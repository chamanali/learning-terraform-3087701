data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}
data "aws_vpc" "default" {
default = true
}

resource "aws_instance" "blog" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  vpc_security_group.ids = ["aws_security_group.blog.id"]
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "blog" {
  name = "blog"
  description = " Allow HTTP/HTTPS inbound. Allow everything out"
  vpc = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog http in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog http out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}
