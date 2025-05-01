data "aws_ami" "imagem_ec2_front_back" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "frontend_backend_sg" {
  name        = "hibp-frontend-backend-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "hibp-frontend-backend-sg"
  }
}

resource "aws_instance" "frontend" {
  count                = 2 # 1 instância para cada AZ
  ami                  = data.aws_ami.imagem_ec2_front_back.id
  instance_type        = "t3.micro"
  subnet_id            = var.private_subnets[count.index % length(var.private_subnets)] # Distribui as EC2s em diferentes subnets, para diferentes AZs
  tags                 = { Name = "hibp-frontend-${count.index}" }
  iam_instance_profile = var.iam_instance_profile_name
  vpc_security_group_ids = [aws_security_group.frontend_backend_sg.id]
}

resource "aws_instance" "backend" {
  count                = 2 # 1 instância para cada AZ
  ami                  = data.aws_ami.imagem_ec2_front_back.id
  instance_type        = "t3.small"
  subnet_id            = var.private_subnets[count.index % length(var.private_subnets)]
  tags                 = { Name = "hibp-backend-${count.index}" }
  iam_instance_profile = var.iam_instance_profile_name
  vpc_security_group_ids = [aws_security_group.frontend_backend_sg.id]

  associate_public_ip_address = true // remover após a versão definitiva
}