output "docker_instance_ip" {
  description = "docker instance internal IP"
  value       = yandex_compute_instance.docker.network_interface.0.ip_address
}

output "docker_instance_ext_ip" {
  description = "docker instance external IP"
  value       = yandex_vpc_address.external-ip-docker.external_ipv4_address.0.address
}
