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
  vpc_security_group_ids = [module.blog_sg.security_group_id]
  tags = {
    Name = "HelloWorld"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name = "blog_1"
  vpc_id = data.aws_vpc.default.id

  ingress_rule       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_block = ["0.0.0.0/0"]

  ingress_rule       = ["all-all"]
  ingress_cidr_block = ["0.0.0.0/0"]
   
}

resource "aws_security_group" "blog" {
  name = "blog"
  description = " Allow HTTP/HTTPS inbound. Allow everything out"
  vpc_id = data.aws_vpc.default.id
}
