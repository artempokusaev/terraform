resource "yandex_vpc_security_group" "docker_sg" {
  name        = "docker_sg"
  description = "Docker SG"
  network_id  = yandex_vpc_network.test-vpc.id

  ingress {
    protocol    = "ANY"
    description = "Разрешает весь трафик от наших сетей"
    from_port   = 0
    to_port     = 65535
    v4_cidr_blocks = [
      var.servers_subnet,
      var.home_subnet,
      var.home_ext_ip,
    ]
  }

  ingress {
    protocol    = "TCP"
    description = "Allow HTTP"
    port        = 80
    v4_cidr_blocks = [
      "0.0.0.0/0", # Разрешаем всем подключение по HTTP
    ]
  }

  ingress {
    protocol    = "TCP"
    description = "Allow HTTPS"
    port        = 443
    v4_cidr_blocks = [
      "0.0.0.0/0", # Разрешаем всем подключение по HTTPS
    ]
  }

  ingress {
    protocol    = "TCP"
    description = "Allow LLM API"
    port        = 8000
    v4_cidr_blocks = [
      var.dev_ip, # interactivemedia.dev IP
    ]
  }

  egress {
    protocol    = "ANY"
    description = "Разрешает исодящий трафик везде"
    from_port   = 0
    to_port     = 65535
    v4_cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
