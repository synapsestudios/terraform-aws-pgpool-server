output "public_ip" {
  description = "The public IP address associated with this PgPool server"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "The public IP address associated with this PgPool server"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "PgPool server's AWS Security Group ID."
  value       = aws_security_group.this.id
}

output "id" {
  description = "PgPool server's Instance ID."
  value       = aws_instance.this.id
}
