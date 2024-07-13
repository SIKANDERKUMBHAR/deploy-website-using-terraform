terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  description = "Policy for EC2 to access S3"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::your-bucket-name",
          "arn:aws:s3:::your-bucket-name/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "testing_ubuntu" {
  ami           = "ami-060e277c0d4cce553"
  instance_type = "t2.micro"
  key_name      = "existing-key-pair-name"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids = [
    data.aws_security_group.main_linux_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              sudo apt-get install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx 
              sudo snap install --classic aws-cli
              sudo rm /var/www/html/*
              sudo -i
              aws s3 sync s3://your-bucket-name  /var/www/html/
              systemctl daemon-reload
              systemctl restart nginx
              EOF

  tags = {
    Name = "testing-ubuntu"
  }
}

data "aws_security_group" "main_linux_sg" {
  filter {
    name   = "group-name"
    values = ["Main-linux-SG"]
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.testing_ubuntu.public_ip
  description = "The public IP address of the EC2 instance"
}
