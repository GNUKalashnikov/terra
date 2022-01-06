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

# to run this use terraform plan
# what plan does is a syntax check much like a --syntax-check
# terraform apply 
