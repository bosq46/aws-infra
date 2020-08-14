# VPC (Virtual Private Cloud)
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.tag_name
  }
}
# インターネットゲートウェイ
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = local.tag_name
  }
}