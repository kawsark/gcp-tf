output "external_ip"{
  value = "${google_compute_instance.demo.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "external_ip_test" {
  value = "${google_compute_instance.demo.network_interface.0.access_config.0.assigned_nat_ip}"
}
