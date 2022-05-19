resource "aws_vpc" "vp" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "r" {
  vpc_id = aws_vpc.vp.id

  tags = {
    Name = "Interngateway1"
  }
}

resource "aws_subnet" "sub_net1" {
  vpc_id     = aws_vpc.vp.id
  cidr_block = "10.0.1.0/24"
  availability_zone ="us-east-1a"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "sub_net2" {
  vpc_id     = aws_vpc.vp.id
  cidr_block = "10.0.0.0/24"
  availability_zone ="us-east-1b"

  tags = {
    Name = "Subnet2"
  }
}


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.sub_net1.id,aws_subnet.sub_net2.id]

  enable_deletion_protection = true

 tags = {
    Environment = "production"
  }
}