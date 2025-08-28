output "vpc_id" {
  value = aws_vpc.terra_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.terra_vpc.cidr_block
}
output "public_subnet_id" {
  value = aws_subnet.public_sub.id
}
output "private_subnet_id" {
  value = aws_subnet.private_sub.id
}
