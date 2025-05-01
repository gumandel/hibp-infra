variable "repo_url" {
  description = "URL do repositório Git com os arquivos de observabilidade"
  type        = string
}

variable "backend_ips" {
  description = "IPs privados das instâncias backend para monitoramento"
  type        = list(string)
}

variable "public_subnets" {
  description = "IDs das subnets públicas"
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "Nome do IAM Instance Profile para SSM"
  type        = string
}

variable "vpc_id" {
  type = string
}