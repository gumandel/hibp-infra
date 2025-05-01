data "aws_ami" "imagem_ec2_observability" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "observability" {
  ami                         = data.aws_ami.imagem_ec2_observability.id
  instance_type               = "t3.medium" 
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.hibp-observability-sg.id]
  iam_instance_profile        = var.iam_instance_profile_name

user_data = <<-EOF
              #!/bin/bash
              # Atualiza o sistema e instala dependências essenciais
              sudo yum update -y
              sudo yum install -y docker git python3 python3-pip libxcrypt-compat

              # Configura e inicia o Docker
              sudo systemctl start docker
              sudo systemctl enable docker

              # Instala o Docker Compose via pip (versão estável mais recente)
              sudo pip3 install --upgrade pip
              sudo pip3 install docker-compose

              # Cria link simbólico para garantir acesso global
              sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

              # Clona o repositório de observabilidade
              git clone ${var.repo_url} /opt/observability || {
                  echo "Falha ao clonar repositório"
                  exit 1
              }

              cd /opt/observability

              # Substitui os IPs dos backends no prometheus.yml
              sed -i "s/172.200.1.1:8000/${var.backend_ips[0]}:8000/g" prometheus/prometheus.yml
              sed -i "s/172.200.2.1:8000/${var.backend_ips[1]}:8000/g" prometheus/prometheus.yml

              # Inicia os containers com verificação de erro
              docker-compose up -d || {
                  echo "Falha ao iniciar containers"
                  docker-compose logs
                  exit 1
              }

              # Verifica se os containers estão rodando
              echo "Containers em execução:"
              docker ps -a
              EOF

  tags = {
    Name = "hibp-observability"
  }
}

# Security Group para Prometheus (9090), Grafana (3000), Node Exporter (9100)
resource "aws_security_group" "hibp-observability-sg" {
  name        = "hibp-observability-sg"
  description = "Libera portas para observabilidade"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3000  # Grafana
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restringir em produção
  }

  ingress {
    from_port   = 9090  # Prometheus
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [for ip in var.backend_ips : "${ip}/32"]  # Apenas as EC2s do backend podem enviar métricas
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Libera saída para a internet
  }
}