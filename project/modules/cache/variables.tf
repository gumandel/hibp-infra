variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Redis será deployado"
}

variable "subnet_ids" {
  type        = list(string)
  description = "IDs das subnets privadas para o Redis"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block da VPC para restringir acesso ao Redis"
  default     = "172.200.0.0/16"
}