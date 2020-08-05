module "http_sg" {
  source            = "../../modules/security_group"
  name              = "module-sg"
  vpc_id            = "vpc-0f21bbe7520f5413e"
  port              = 80
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}

module "https_sg" {
  source            = "../../modules/security_group"
  name              = "https-sg"
  vpc_id            = "vpc-0f21bbe7520f5413e"
  port              = 443
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}

module "http_redirect_sg" {
  source            = "../../modules/security_group"
  name              = "http-redirect-sg"
  vpc_id            = "vpc-0f21bbe7520f5413e"
  port              = 8080
  cidr_blocks       = ["0.0.0.0/0"]
  instance_tag_name = "terraform-training"
}
