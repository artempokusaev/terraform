resource "yandex_compute_disk" "docker-data" {
  name       = "docker-data"
  type       = "network-ssd-io-m3"
  size       = 93
  block_size = 4096
  zone       = var.zone
}
