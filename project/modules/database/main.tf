resource "aws_security_group" "rds_sg" {
  name        = "hibp-rds-sg"
  description = "Permite acesso ao PostgreSQL apenas de dentro da VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432  # Porta padrão do PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]  # Restringe ao CIDR da VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Libera saída para qualquer lugar
  }

  tags = {
    Name = "hibp-rds-sg"
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "hibp-postgres-subnet-group"
  subnet_ids = var.private_subnets # Recebe as subnets privadas do módulo VPC

  tags = {
    Name = "Postgres DB Subnet Group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage   = 20
  engine              = "postgres"
  engine_version      = "17.4"
  instance_class      = "db.t3.micro"
  db_name             = "hibp_db"
  username            = local.db_credentials.username
  password            = local.db_credentials.password
  backup_retention_period = 7
  skip_final_snapshot = true  # Se false, cria um backup automático antes de dar destroy (ativar em produção)
  multi_az            = false # Ativar em produção
  db_subnet_group_name = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # Usa o SG criado acima
}

resource "aws_db_instance" "replica" {
  replicate_source_db = aws_db_instance.postgres.identifier
  instance_class = "db.t3.micro"
  availability_zone = "us-west-2b" # AZ diferente da primeira
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = "hibp-db-credentials"
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}

