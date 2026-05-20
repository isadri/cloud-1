data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "web" {
  image  = var.image
  name   = var.droplet_name
  region = var.region
  size   = var.size

  ssh_keys = [data.digitalocean_ssh_key.default.id]
}

resource "digitalocean_firewall" "web" {
  name        = "web-firewall"
  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# create a project to group our resources
resource "digitalocean_project" "cloud1" {
  name        = "cloud1"
  description = "Project for cloud1 resources"
  purpose     = "Web Application"
  environment = "Production"
  resources = [
    "do:droplet:${digitalocean_droplet.web.id}",
    "do:firewall:${digitalocean_firewall.web.id}",
  ]
}

resource "local_file" "droplet_ip" {
  filename = "../../deploy/inventories/digitalocean/hosts.ini"
  content  = <<EOT
  [webserver]
  cloud1_server ansible_host=${digitalocean_droplet.web.ipv4_address}
  [webserver:vars]
  ansible_user=root
  ansible_ssh_private_key_file=~/.ssh/id_ed25519
  EOT
}