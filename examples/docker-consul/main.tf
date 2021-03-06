# Example instantiation for terraform-gcp-compute-instance as a module
# Using the startup-script Apache HTTPD server and Mysql are installed as systemd services

provider "google" {
  region      = var.gcp_region
}

variable "gcp_project" {
  description = "Name of GCP project"
}

variable consul_version {
  default = "1.7.2"
}

variable gcp_region {
  default = "us-east1"
}

data "template_file" "startup_script" {
  template = file("${path.module}/consul.sh.tpl")
  vars = {
    public_key = tls_private_key.pem.public_key_openssh
    consul_version = var.consul_version
    datacenter = var.gcp_region
  }
}

resource "tls_private_key" "pem" {
  algorithm   = "RSA"
  rsa_bits = "2048"
}

module "consul-server" {
  #  source = "github.com/kawsark/terraform-gcp-compute-instance"
  source = "../../"
  labels = {
    environment = "dev"
    app         = "consul"
    ttl         = "24"
    owner       = "kawsar-at-hashicorp"
  }
  gcp_project    = var.gcp_project
  gcp_region     = var.gcp_region
  instance_name  = "consul-server"
  startup_script = data.template_file.startup_script.rendered
  image          = "ubuntu-os-cloud/ubuntu-1804-lts"
  os_pd_ssd_size = "20"
}

output "external_ip" {
  value = module.consul-server.external_ip
}

output "id" {
  value = module.consul-server.id
}

output "name" {
  value = module.consul-server.name
}

output "private_key" {
  value = tls_private_key.pem.private_key_pem
  description = "The private key for logging onto the server"
  sensitive   = true
}

