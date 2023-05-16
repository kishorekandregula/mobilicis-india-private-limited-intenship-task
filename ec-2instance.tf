# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create a new VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach the internet gateway to the VPC
resource "aws_vpc_attachment" "my_vpc_attachment" {
  vpc_id             = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}

# Create a new subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"  # Replace with your desired availability zone
}

# Create a security group for the instances
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow inbound traffic on port 80"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instances
resource "aws_instance" "my_instance1" {
  ami           = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_instance" "my_instance2" {
  ami           = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

# Create a load balancer
resource "aws_elb" "my_load_balancer" {
  name               = "my-load-balancer"
  subnets            = [aws_subnet.my_subnet.id]
  security_groups    = [aws_security_group.my_security_group.id]
  instances          = [aws_instance.my_instance1.id, aws_instance.my_instance2.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}

