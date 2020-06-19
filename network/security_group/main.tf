# security group module
variable "name" {}
variable "vpc_id" {}
variable "port" {}
variable "cidr_blocks" {
  # 指定しないと any 型となる
  # 指定するエラーが出る
  type = list(string)
}
variable "instance_tag_name" {}

# AWS の firewall
## ネットワークACL：サブネットレベル
## セキュリティグループ：インスタンスレベル
resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.instance_tag_name
  }
}
# インバウンド
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
}
# アウトバウンド
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

output "security_group_id" {
  value = aws_security_group.default.id
}