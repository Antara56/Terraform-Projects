
# resource "aws_instance" "Instance_eni" {
#   ami           = "ami-0022f774911c1d690"
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "Terraform Demo"
#   }
# }

resource "aws_vpc" "vp1" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.vp1.id
  cidr_block = "10.0.0.0/24"
  availability_zone ="us-east-1a"


  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vp1.id

 ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
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

resource "aws_network_interface" "net" {
  subnet_id       = aws_subnet.sub1.id
  security_groups = [aws_security_group.allow_tls.id]

#   attachment {
#     instance     = aws_instance.Instance_eni.id
#     device_index = 1
#   }
}