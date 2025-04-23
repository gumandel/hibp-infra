data "aws_ami" "imagem_ec2_front_back" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "frontend" {
  count         = 2 # 1 instância para cada AZ
  ami           = data.aws_ami.imagem_ec2_front_back.id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnets[count.index % length(var.public_subnets)] # Distribui as EC2s em diferentes subnets, para diferentes AZs
  tags          = { Name = "hibp-frontend-${count.index}" }
  key_name      = "hibp-keypair" 
}

resource "aws_instance" "backend" {
  count         = 2 # 1 instância para cada AZ
  ami           = data.aws_ami.imagem_ec2_front_back.id
  instance_type = "t3.small"
  subnet_id     = var.private_subnets[count.index % length(var.private_subnets)]
  tags          = { Name = "hibp-backend-${count.index}" }
  key_name      = "hibp-keypair"
  
  associate_public_ip_address = true 
}