resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow Postgres inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow Postgres"
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  tags = {
    Name = "allow_postgres"
  }
}
