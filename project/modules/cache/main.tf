resource "aws_security_group" "redis_sg" {
  name   = "hibp-redis-sg"
  vpc_id = var.vpc_id

  # Regra de entrada (apenas na porta 6379 e dentro da VPC)
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # Restringe ao CIDR da VPC
  }

  tags = {
    Name = "hibp-redis-sg"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "hibp-redis"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1                                # Para testes (em prod, usar réplicas)
  security_group_ids = [aws_security_group.redis_sg.id] # Usa o SG criado acima
  subnet_group_name  = aws_elasticache_subnet_group.redis.name
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "hibp-redis-subnet-group"
  subnet_ids = var.subnet_ids # Vindo do main.tf raiz
}