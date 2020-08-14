# パブリックサブネット
# マルチAZ
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = local.tag_name
  }
}
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = local.tag_name
  }
}
# ルートテーブル
# VPC内の通信をするため、ローカルルートが自動生成される
# Terraformで制御できない
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = local.tag_name
  }
}
# ルート (ルートテーブルの1レコードに該当)
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id     = aws_internet_gateway.example.id
  # デフォルトルート(0.0.0.0/0)：
  # VPC以外への通信をインターネットゲートウェイ経由でインターネットへ流す
  destination_cidr_block = "0.0.0.0/0"
}
# ルートテーブルとサブネットの関連付け
# 忘れるとデフォルトが使われるがアンチパターンとなる
resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}