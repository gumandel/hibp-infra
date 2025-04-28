output "iam_instance_profile_name" {
  description = "Nome do IAM Instance Profile para uso nas EC2"
  value       = aws_iam_instance_profile.ssm_ec2_profile.name
}