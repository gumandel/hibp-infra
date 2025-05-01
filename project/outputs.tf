output "frontend_public_ips" {
  value = module.frontend_backend.frontend_public_ips
  description = "Public IPs of the frontend instances"
}

output "backend_public_ips" {
  value = module.frontend_backend.backend_public_ips
  description = "Public IPs of the backend instances"
}