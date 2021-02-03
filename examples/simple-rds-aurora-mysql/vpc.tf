resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "db_subnets" {
  count = 3

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnets("10.0.0.0/16", 8, 8, 8)[count.index]

  availability_zone_id = local.zones[count.index]
}