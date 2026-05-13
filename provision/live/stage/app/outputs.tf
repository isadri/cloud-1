output "public_dns" {
  description = "The public DNS of the instance"
  value       = module.web_server.public_dns
}