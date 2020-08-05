module "instance" {
  source            = "../../modules/http_server"
  instance_type     = "t3.micro"
  instance_tag_name = "httpd-app"
  vpc_security_group_ids = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id
  ]
  subnet_id = "subnet-0ebf67974d997dd8b" #public-network
}