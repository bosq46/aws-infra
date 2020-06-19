variable "instance_type" {}
variable "instance_tag_name" {}
// variable "aws_security_group" {}

resource "aws_instance" "default" {
  ami = "ami-0c3fd0f5d33134a76"
  // vpc_security_group_ids = var.aws_security_group
  instance_type = var.instance_type
  tags = {
    Name = var.instance_tag_name
  }
  user_data = <<EOF
  #!/bin/bash
  yum install -y httpd
  systemctl start httpd.service
EOF
}

output "public_dns" {
  value = aws_instance.default.public_dns
}