module "http_sg" {
  source            = "./security_group"
  name              = "module-sg"
  vpc_id            = aws_vpc.example.id
  port              = 80
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}

module "https_sg" {
  source            = "./security_group/"
  name              = "https-sg"
  vpc_id            = aws_vpc.example.id
  port              = 443
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}

module "http_redirect_sg" {
  source            = "./security_group/"
  name              = "http-redirect-sg"
  vpc_id            = aws_vpc.example.id
  port              = 8080
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}
