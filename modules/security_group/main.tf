resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.tag
    Env = var.env
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