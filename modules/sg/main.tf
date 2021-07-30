terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.47.0"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Test #51892"
  }
}

resource "aws_security_group" "allow_efs" {
  name        = "atanas-test"
  description = "Allow NFS inbound traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "Allow inbound NFS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.example.cidr_block]
  }

  egress {
    description      = "egress all allowed"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.example.cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group_rule" "efs_udp" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "udp"
  cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = aws_security_group.allow_efs.id
}
