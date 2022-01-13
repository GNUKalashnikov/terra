
# To create and destroy infrastructure at will


#Note find if this is compiled or interpreted
# Point to the cloud provider
provider "aws" {
	region = "eu-west-1"
}


resource "aws_vpc" "Ivan_terra_vpc" {
    cidr_block = var.cidr_block
    tags = {
      Name = "Ivan_terra_vpc"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Ivan_terra_vpc.id
  tags = {
    Name : "ivan_terra_ig"
  }
}

resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.Ivan_terra_vpc.id
  cidr_block = var.aws_public_cidr
  tags = {
    Name = "public_sub_terra"
  }
}


resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.Ivan_terra_vpc.id
  cidr_block = var.aws_private_cidr
  tags = {
    Name = "private_sub_terra"
  }
}

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.Ivan_terra_vpc.id
  route {
    cidr_block = var.aws_open_port
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.public_route_table
  }
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.Ivan_terra_vpc.id
  route {
    cidr_block = var.aws_open_port
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.private_route_table
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.Public_RT.id
}

# Associating Private Subnet to routing table
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.Private.id
  route_table_id = aws_route_table.Private_RT.id
}

resource "aws_security_group" "public" {
  name        = "allow_public_access"
  description = "allow_public_access"
  vpc_id      = aws_vpc.Ivan_terra_vpc.id
}

# Security group Private DB
resource "aws_security_group" "private" {
  name = "db_sg"
  description = "db_sg"
  vpc_id = aws_vpc.Ivan_terra_vpc.id
}

resource "aws_security_group_rule" "app_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
  cidr_blocks       = [var.aws_open_port]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "app_outbound" {
  type = "egress"
  protocol = "-1"
  from_port = "0"
  to_port = "0"
  cidr_blocks = [var.aws_open_port]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "db" {
  type = "ingress"
  protocol = "tcp"
  from_port = "0"
  to_port = "27017"
  cidr_blocks = [var.aws_public_cidr]
  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "db_outbound" {
  type = "egress"
  protocol = "-1"
  from_port = "0"
  to_port = "0"
  cidr_blocks = [var.aws_open_port]
  security_group_id = aws_security_group.private.id
}

resource "aws_instance" "controller_instance" {
  ami = var.app_ami_id
  subnet_id = aws_subnet.Public.id
  instance_type = var.aws_instance_type
  security_groups = [aws_security_group.public.id]
  associate_public_ip_address = true
  tags = {
    Name = var.controller_name
  }
  key_name = var.aws_key_name
}


# App Instance
resource "aws_instance" "app_instance" {
  # AMI id for 18.04LTS
  ami             = var.app_ami_id
  subnet_id       = aws_subnet.Public.id
  instance_type   = var.aws_instance_type
  security_groups = [aws_security_group.public.id]
  associate_public_ip_address = true
  tags = {
    Name = var.name
  }
  # Allows terraform to use eng99.pem to connect to instance
  # Looks in .ssh folder
  key_name = var.aws_key_name
}

# DB Instance
resource "aws_instance" "db_instance" {
  ami = var.app_ami_id
  subnet_id = aws_subnet.Private.id
  instance_type = var.aws_instance_type
  security_groups = [aws_security_group.private.id]
  associate_public_ip_address = true
  tags = {
    Name = var.db_name
  }
  key_name = var.aws_key_name
}

# to run this use terraform plan
# what plan does is a syntax check much like a --syntax-check
# terraform apply


