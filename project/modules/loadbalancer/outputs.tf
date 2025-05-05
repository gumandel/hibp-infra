output "nginx_ec2_public_ip" {
  description = "IP público da instância NGINX Load Balancer"
  value       = aws_instance.hibp_nginx_ec2.public_ip
}

output "nginx_ec2_instance_id" {
  description = "ID da instância do nginx"
  value       = aws_instance.hibp_nginx_ec2.id
}