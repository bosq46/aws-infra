resource "aws_lb" "httpbin" {
  name = "alb-httpbin"
  # ALB = "application, NLB = "network"
  load_balancer_type = "application"
  # インターネット向けのためinternal=false
  internal = false
  # default = 60
  idle_timeout = 60
  # 削除可能か
  enable_deletion_protection = false

  subnets = [
    var.public_subnet_0_id,
    var.public_subnet_1_id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
  ]

  tags = {
    Name = local.tag
    Env  = var.env
  }
}

# HTTP リスナー
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.httpbin.arn
  # 1 ~ 65535
  port     = "80"
  protocol = "HTTP"

  # forward, fixed-response, redirect
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "http default page."
      status_code  = "200"
    }
  }
}
# ターゲットグループ
resource "aws_lb_target_group" "example" {
  name = "example"
  target_type = "ip"
  # IP は以下３つを設定する
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"
  # 登録解除の待機時間 default:300sec
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  # ALBとターゲット不ループをECSと同時に作成するとエラーになるため依存関係を書く
  depends_on = [aws_lb.httpbin]
}
# リスナールール
resource "aws_lb_listener_rule" "example" {
  # listener_arn = aws_lb_listener.https.arn
  listener_arn = aws_lb_listener.http.arn
  # 優先順位: 小さいほど優先順位は高い
  # default: 最も高い
  priority = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}