output "grafana_url" {
    value = "http://${aws_instance.observability.public_ip}:3000"
}