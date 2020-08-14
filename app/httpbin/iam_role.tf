#################
# ECS タスク実行 # 
#################
module ecs_task_execution_role {
  source     = "../../modules/iam_role"
  name       = "ecs-task-executuion"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_task_execution_policy.policy
}
# ポリシーデータソース
# AWS が管理するポリシー
data "aws_iam_policy" "ecs_task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
##############
# S3 の Role #
##############
# resource "aws_iam_role" "mori_s3_role" {
#   name               = "s3_task_role"
#   assume_role_policy = data.aws_iam_policy_document.s3_assume_policy.json
#   tags = {
#     Name = "intern: mori"
#     Env  = local.env
#   }
# }
# data "aws_iam_policy_document" "s3_assume_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }
# resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
#   role = aws_iam_role.mori_s3_role.name
#   # policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   policy_arn = aws_iam_policy.s3task_policy.arn
# }
# resource aws_iam_policy "s3task_policy" {
#   name        = "s3_policy"
#   description = "s3_policy"
#   policy      = data.aws_iam_policy_document.s3_policy.json
# }
# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
#     resources = [
#       "arn:aws:s3:::${var.s3_bucket_name}/test-from-ecs/",
#       "arn:aws:s3:::${var.s3_bucket_name}/test-from-ecs/*",
#     ]
#   }
# }
#######################
# ECS スケジュールタスク #
#######################
# resource "aws_iam_role" "mori_ecs_schedule_role" {
#   name               = "mori_ecs_schedule_role"
#   assume_role_policy = data.aws_iam_policy_document.scheduled_task_assume_policy.json
#   tags = {
#     Name = "intern: mori"
#     Env  = local.env
#   }
# }
# data "aws_iam_policy_document" "scheduled_task_assume_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#   }
# }
# resource "aws_iam_role_policy_attachment" "ecsscheduledtasks_role_attach" {
#   role       = aws_iam_role.mori_ecs_schedule_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
# }