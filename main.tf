# Point to the cloud provider
provider "aws" {
	region = "eu-west-1"
}

resource "aws_instance" "app_instance" {
	ami = var.app_ami_id
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
	    Name = "eng99_ivan_terrafrom_app"
	}
	key_name = "eng99"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name 
  cidr = var.cidr_block

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false 
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# to run this use terraform plan
# what plan does is a syntax check much like a --syntax-check
# terraform apply 
resource "aws_security_group" "allow_tls" {
  name        = "eng99_ivan_terraform"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "access the app from anywhere world"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "ssh from world"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

