resource "aws_instance" "default" {
  ami                    = "ami-0c3fd0f5d33134a76"
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = {
    Name = var.instance_tag_name
  }
  availability_zone = "ap-northeast-1a"
  subnet_id         = var.subnet_id
  user_data         = <<EOF
  #!/bin/bash
  yum install -y httpd
  systemctl start httpd.service
EOF
}