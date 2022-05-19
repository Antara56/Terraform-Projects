resource "aws_iam_role" "development_role" {
  name = "development_role"


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

  tags = {
    tag-key = "developer"
  }
}