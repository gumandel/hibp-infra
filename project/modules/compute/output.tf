output "frontend_public_ips" {
  description = "Lista de IPs públicos das instâncias frontend"
  value       = aws_instance.frontend[*].public_ip
}

output "backend_public_ips" {
  description = "Lista de IPs públicos das instâncias backend"
  value       = aws_instance.backend[*].public_ip
}

output "frontend_private_ips" {
  description = "Lista de IPs privados das instâncias backend"
  value       = aws_instance.frontend[*].private_ip
}

output "backend_private_ips" {
  description = "Lista de IPs privados das instâncias backend"
  value       = aws_instance.backend[*].private_ip
}

output "frontend_instance_ids" {
  description = "Lista de IDs das instâncias EC2s frontend"
  value       =  aws_instance.frontend[*].id
}

output "backend_instance_ids" {
  description = "Lista de IDs das instâncias EC2s backend"
  value       =  aws_instance.backend[*].id
}