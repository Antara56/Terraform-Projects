
resource "aws_vpc" "vp" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sub_netl" {
  vpc_id     = aws_vpc.vp.id
  cidr_block = "10.0.1.0/24"
  availability_zone ="us-east-1a"

  tags = {
    Name = "SubnetL"
  }
}

resource "aws_subnet" "sub_netm" {
  vpc_id     = aws_vpc.vp.id
  cidr_block = "10.0.0.0/24"
  availability_zone ="us-east-1b"

  tags = {
    Name = "SubnetM"
  }
}

resource "aws_ebs_volume" "example1" {
  availability_zone = "us-east-1a"
  size              = 40
}

resource "aws_ebs_snapshot" "example2" {
  volume_id = aws_ebs_volume.example1.id
}


resource "aws_ami" "example3" {
  name                = "aws_ami"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.example2.id
    volume_size = 100
  }
}

resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = aws_ami.example3.id
  instance_type = "t2.micro"
}



resource "aws_autoscaling_group" "bar"{
  name                      = "foobar3-terraform-test"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.sub_netl.id, aws_subnet.sub_netm.id]

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}
resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags={
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
}