variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block da VPC para restringir acesso ao RDS"
  default     = "172.200.0.0/16"
}