output "security_group_id" {
  description = "The Security Group ID"
  value       = aws_security_group.allow_access.id
}

output "public_dns" {
  description = "The public DNS of the instance"
  value       = aws_instance.app.public_dns
}

output "instance_id" {
  description = "The instance ID"
  value       = aws_instance.app.id
}