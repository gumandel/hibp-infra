# IAM Role para o SSM (usada pelas EC2)
resource "aws_iam_role" "ssm_ec2_role" {
  name        = "hibp-ssm-ec2-role-${var.environment}"
  description = "Permite que instâncias EC2 usem o SSM Session Manager"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Attach da política gerenciada da AWS
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile (vincula a role às EC2)
resource "aws_iam_instance_profile" "ssm_ec2_profile" {
  name = "hibp-ssm-ec2-profile-${var.environment}"
  role = aws_iam_role.ssm_ec2_role.name
}