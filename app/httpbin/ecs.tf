########################################
# ECS Cluster (httpbin)
########################################
resource "aws_ecs_cluster" "infra_cluster" {
  name = "infra_cluster"
  tags = {
    Name = local.tag
    Env  = var.env
  }
}
########################################
# ECS Task (httpbin)
########################################
resource "aws_ecs_task_definition" "httpbin" {
  family                   = "httpbin"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  tags = {
    Name = local.tag
    Env  = var.env
  }
}
resource "aws_cloudwatch_log_group" "httpbin" {
  name              = "/aws/ecs/httpbin"
  retention_in_days = 1
}
########################################
# ECS サービス
########################################
resource "aws_ecs_service" "httpbin" {
  name             = "httpbin"
  cluster          = aws_ecs_cluster.infra_cluster.arn
  task_definition  = aws_ecs_task_definition.httpbin.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.3.0"
  health_check_grace_period_seconds = 60 # default: 0

  network_configuration {
    assign_public_ip = false
    security_groups  = [
      # module.httpbin_sg.security_group_id
      module.http_sg.security_group_id
    ]
    subnets = [
      var.private_subnet_0_id,
      var.private_subnet_1_id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.example.arn
    container_name   = "httpbin"
    container_port   = 80
  }

  # デプロイの度に更新されるので無視
  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
  # tags = {
  #   Name = local.tag
  #   Env  = var.env
  # }
}