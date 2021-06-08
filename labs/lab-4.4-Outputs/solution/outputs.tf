output "bastion-public-ip" {
  value = aws_instance.lab-bastion.public_ip
}

output "db-server-endpoint" {
  value = aws_db_instance.lab-database.endpoint
}
