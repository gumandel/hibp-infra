variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "vpc_id" {
  type        = string
}