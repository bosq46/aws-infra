module "http_sg" {
  source      = "../../modules/security_group"
  name        = "alb-http-sg"
  vpc_id      = var.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
  tag         = local.tag
  env         = var.env
}

module "httpbin_sg" {
  source      = "../../modules/security_group"
  name        = "httpbin-sg"
  vpc_id      = var.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
  tag         = local.tag
  env         = var.env
}