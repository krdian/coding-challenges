resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "sre-challenge-vpc"
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = "arn:aws:logs:eu-west-1:246680697913:log-group:/aws/vpc/flow-logs"
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}

resource "aws_subnet" "this" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "eu-west-1a"
  tags = {
    Name = "sre-challenge-subnet-${each.key}"
  }
}
resource "aws_nat_gateway" "this" {
  //allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.this["main"].id
  tags = {
    Name = "sre-challenge-nat-gateway"
  }
}