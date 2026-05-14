output "public_dns" {
  description = "The public DNS of the instance"
  value       = module.web_server.public_dns
}

output "instance_id" {
  description = "The instance ID"
  value       = module.web_server.instance_id
}