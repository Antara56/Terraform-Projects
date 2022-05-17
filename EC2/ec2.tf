resource "aws_instance" "Terraform_Demo" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform Demo"
  }
}