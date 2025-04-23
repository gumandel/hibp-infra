output "frontend_public_ips" {
  description = "Lista de IPs públicos das instâncias frontend"
  value       = aws_instance.frontend[*].public_ip
}

output "backend_public_ips" {
  description = "Lista de IPs públicos das instâncias backend"
  value       = aws_instance.backend[*].public_ip
}