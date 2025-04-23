output "frontend_public_ips" {
  value = module.frontend.frontend_public_ips
  description = "Public IPs of the frontend instances"
}

output "backend_public_ips" {
  value = module.frontend.backend_public_ips
  description = "Public IPs of the backend instances"
}