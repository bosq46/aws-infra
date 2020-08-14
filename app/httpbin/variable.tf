# Service
variable env {
  type        = string
  default     = "dev"
  description = "Environment"
}
# Network
variable vpc_id {
  type        = string
  default     = "vpc-"
  description = "for private infra VPC."
}
variable private_subnet_0_id {
  type        = string
  default     = "private_subnet_0_id"
  description = "for private VPC subnet."
}
variable private_subnet_1_id {
  type        = string
  default     = "private_subnet_1_id"
  description = "for private VPC subnet."
}
variable public_subnet_0_id {
  type        = string
  default     = "public_subnet_0_id"
  description = "for public VPC subnet."
}
variable public_subnet_1_id {
  type        = string
  default     = "public_subnet_1_id"
  description = "for public VPC subnet."
}
# Application
variable s3_bucket_name {
  type        = string
  default     = "s3_bucket_name"
  description = "s3 bucket name"
}
variable log_bucket_name {
  type        = string
  default     = "log_bucket_name"
  description = "ALB log bucket"
}
