variable "name" {}
variable "vpc_id" {}
variable "port" {}
variable "cidr_blocks" {
  # 指定しないと any 型となる
  # 指定するエラーが出る
  type = list(string)
}
variable "instance_tag_name" {}