resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow MySQL"
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  tags = {
    Name = "allow_mysql"
  }
}
