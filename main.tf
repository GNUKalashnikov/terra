# Point to the cloud provider
provider "aws" {
	region = "eu-west-1"
}

resource "aws_instance" "app_instance" {
	ami = "ami-07d8796a2b0f8d29c"
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
	    Name = "eng99_ivan_terrafrom_app"
	}
	key_name = "eng99"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eng99_ivan_vpc_terra"
  cidr = var.cidr_block

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# to run this use terraform plan
# what plan does is a syntax check much like a --syntax-check
# terraform apply 
