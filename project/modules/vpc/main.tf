resource "aws_vpc" "hibp_vpc" {
  cidr_block           = "172.200.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "hibp-vpc"
  }
}

resource "aws_subnet" "sn_priv01" {
  vpc_id            = aws_vpc.hibp_vpc.id
  cidr_block        = "172.200.1.0/24"
  availability_zone = "us-west-2c"
  tags = {
    Name = "hibp-sn_priv01"
  }
}
resource "aws_subnet" "sn_priv02" {
  vpc_id            = aws_vpc.hibp_vpc.id
  cidr_block        = "172.200.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "hibp-sn_priv02"
  }
}
resource "aws_subnet" "sn_pub01" {
  vpc_id            = aws_vpc.hibp_vpc.id
  cidr_block        = "172.200.3.0/24"
  availability_zone = "us-west-2c"
  tags = {
    Name = "hibp-sn_pub01"
  }
}
resource "aws_subnet" "sn_pub02" {
  vpc_id            = aws_vpc.hibp_vpc.id
  cidr_block        = "172.200.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "hibp-sn_pub02"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hibp_vpc.id
  tags = {
    Name = "hibp-igw"
  }
}

resource "aws_route_table" "route_pub" {
  vpc_id = aws_vpc.hibp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "hibp-routetable"
  }
}

resource "aws_route_table_association" "pub01assoc" {
  subnet_id      = aws_subnet.sn_pub01.id
  route_table_id = aws_route_table.route_pub.id
}
resource "aws_route_table_association" "pub02assoc" {
  subnet_id      = aws_subnet.sn_pub02.id
  route_table_id = aws_route_table.route_pub.id
}

# SSM 

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.hibp_vpc.id
  service_name      = "com.amazonaws.${var.project_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.sn_priv01.id,
    aws_subnet.sn_priv02.id
  ]
  security_group_ids = [aws_security_group.sg_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name = "hibp-endpoint-ssm"
  }
}

# SSM Messages

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.hibp_vpc.id
  service_name      = "com.amazonaws.${var.project_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.sn_priv01.id,
    aws_subnet.sn_priv02.id
  ]
  security_group_ids = [aws_security_group.sg_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name = "hibp-endpoint-ssmmessages"
  }
}

# EC2 Messages

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.hibp_vpc.id
  service_name      = "com.amazonaws.${var.project_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.sn_priv01.id,
    aws_subnet.sn_priv02.id
  ]
  security_group_ids = [aws_security_group.sg_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name = "hibp-endpoint-ec2messages"
  }
}

# Security group SSM

resource "aws_security_group" "sg_endpoints" {
  name        = "hibp-endpoints-sg"
  description = "Permite HTTPS entre EC2 e os VPC Endpoints SSM"
  vpc_id      = aws_vpc.hibp_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.200.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hibp-sg-endpoints"
  }
}