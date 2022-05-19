resource "aws_vpc" "vcm" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "er" {
  vpc_id = aws_vpc.vcm.id

  tags = {
    Name = "Interngateway"
  }
}

resource "aws_subnet" "sub_netA" {
  vpc_id     = aws_vpc.vcm.id
  cidr_block = "10.0.1.0/24"
  availability_zone ="us-east-1a"

  tags = {
    Name = "SubnetA"
  }
}

resource "aws_subnet" "sub_netB" {
  vpc_id     = aws_vpc.vcm.id
  cidr_block = "10.0.0.0/24"
  availability_zone ="us-east-1b"

  tags = {
    Name = "SubnetB"
  }
}


resource "aws_lb" "teste" {
  name               = "teste-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.sub_netA.id,aws_subnet.sub_netB.id]

  enable_deletion_protection = true

 tags = {
    Environment = "production"
  }
}