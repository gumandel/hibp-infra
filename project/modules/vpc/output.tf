output "vpc_id" {
  value = aws_vpc.hibp_vpc.id
}
output "sn_priv01_id" {
  value = aws_subnet.sn_priv01.id
}
output "sn_priv02_id" {
  value = aws_subnet.sn_priv02.id
}
output "sn_pub01_id" {
  value = aws_subnet.sn_pub01.id
}
output "sn_pub02_id" {
  value = aws_subnet.sn_pub02.id
}