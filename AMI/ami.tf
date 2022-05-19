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