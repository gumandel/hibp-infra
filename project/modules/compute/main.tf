data "aws_ami" "imagem_ec2_front_back" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "frontend" {
  count                = 2 # 1 instância para cada AZ
  ami                  = data.aws_ami.imagem_ec2_front_back.id
  instance_type        = "t3.micro"
  subnet_id            = var.private_subnets[count.index % length(var.private_subnets)] # Distribui as EC2s em diferentes subnets, para diferentes AZs
  tags                 = { Name = "hibp-frontend-${count.index}" }
  key_name             = "hibp-keypair"
  iam_instance_profile = var.iam_instance_profile_name
}

resource "aws_instance" "backend" {
  count                = 2 # 1 instância para cada AZ
  ami                  = data.aws_ami.imagem_ec2_front_back.id
  instance_type        = "t3.small"
  subnet_id            = var.private_subnets[count.index % length(var.private_subnets)]
  tags                 = { Name = "hibp-backend-${count.index}" }
  key_name             = "hibp-keypair"
  iam_instance_profile = var.iam_instance_profile_name

  associate_public_ip_address = true // remover após a versão definitiva
}