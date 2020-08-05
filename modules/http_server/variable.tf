variable "instance_type" {}
variable "instance_tag_name" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "subnet_id" {}