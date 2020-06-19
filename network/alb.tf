resource "aws_lb" "alb" {
  name = "alb-example"
  # ALB = "application, NLB = "network"
  load_balancer_type = "application"
  # インターネット向けのためinternal=false
  internal = false
  # default = 60
  idle_timeout               = 60
  # 削除可能か
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]

  tags = {
    Name = "terraform-training"
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

# HTTP リスナー
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  # 1 ~ 65535
  port     = "80"
  protocol = "HTTP"

  # 複数のルールに応じたアクションが実行される
  # 以下，３つがある
  # forward, fixed-response, redirect
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは「HTTP」です!"
      status_code  = "200"
    }
  }
}
# HTTPS リスナー
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port     = "443"
#   protocol = "HTTPS"
#   certificate_arn = aws_acm_certificate.example.arn
#   ssl_policy = "ELBSecurityPolicy-2016-08"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "これは「HTTPS」です!"
#       status_code  = "200"
#     }
#   }
# }
# HTTPS リスナー
# resource "aws_lb_listener" "redirect_http_to_https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port     = "8080"
#   protocol = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port = "443"
#       protocol = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# リクエストフォワード
resource "aws_lb_target_group" "example" {
  name = "example"
  # tart_type: EC2 instance, IP, lambda などを指定
  # ECS Fargate -> IP
  target_type = "ip"
  # IP は以下３つを設定する
  vpc_id = aws_vpc.example.id
  port = 80
  protocol = "HTTP"
  # 登録解除の待機時間 default:300sec
  deregistration_delay = 300

  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = 200
    port = "traffic-port"
    protocol = "HTTP"
  }
  # ALBとターゲット不ループをECSと同時に作成するとエラーになるため依存関係を書く
  depends_on = [aws_lb.alb]
}
# リスナールール
# resource "aws_lb_listener_rule" "example" {
#   listener_arn = aws_lb_listener.https.arn
#   # 優先順位: 小さいほど優先順位は高い
#   # default: 最も高い
#   priority = 100

#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.example.arn
#   }

#   condition {
#     field = "path-pattern"
#     values = ["/*"]
#   }
# }