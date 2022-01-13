# In tis file we will make in the main

variable "name" {
	default = "eng99_ivan_app_instance"
}

variable "db_name"{
	default = "eng99_ivan_db_instance"
}

variable "app_ami_id" {
	default = "ami-07d8796a2b0f8d29c"
}

variable "vpc_id" {
	default = "eng99_ivan_vpc_terra"
}

variable "aws_public_subnet" {
	default = "eng99_ivan_terraform_public_sn"
}

variable "aws_key_name" {
	default = "eng99"
}

variable "cidr_block"{
	default = "10.0.0.0/16"
}

variable "aws_public_cidr" {
  	default = "10.0.0.0/24"
}
variable "aws_private_cidr" {
  	default = "10.0.1.0/24"
}
variable "aws_open_port" {
  	default = "0.0.0.0/0"
}
variable "controller_name" {
  default = "eng99_ivan_terraform_controller"
}

variable "aws_instance_type" {
  	default = "t2.micro"
}

variable "public_route_table" {
  	default = "Public Route Table"
}

variable "private_route_table" {
  	default = "Private Route Table"
}

