output "frontend_public_ips" {
  description = "IPs públicos das instâncias frontend"
  value = module.frontend_backend.frontend_public_ips
}

output "backend_public_ips" {
  description = "IPs públicos das instâncias backend"
  value = module.frontend_backend.backend_public_ips
}

output "frontend_instance_ids" {
  description = "Lista de IDs das instâncias EC2s frontend"
  value       =  module.frontend_backend.frontend_instance_ids
}

output "backend_instance_ids" {
  description = "Lista de IDs das instâncias EC2s backend"
  value       = module.frontend_backend.backend_instance_ids
}