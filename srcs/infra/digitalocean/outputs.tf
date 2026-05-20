
output "public_ip" {
  description = "IPv4 address of the Droplet"
  value       = digitalocean_droplet.web.ipv4_address
}

output "instance_id" {
  description = "The Droplet ID"
  value       = digitalocean_droplet.web.id
}