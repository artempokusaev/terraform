resource "yandex_vpc_network" "test-vpc" {
  name = "main"
}

resource "yandex_vpc_subnet" "servers" {
  name           = "servers"
  v4_cidr_blocks = [var.servers_subnet]
  network_id     = yandex_vpc_network.test-vpc.id
}

resource "yandex_vpc_address" "external-ip-docker" {
  name = "external-ip-docker"
  external_ipv4_address {
    zone_id = var.zone
  }
}

resource "yandex_compute_instance" "docker" {
  name                      = "docker"
  hostname                  = "docker"
  description               = "VM for docker server"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.docker-data.id
    device_name = "vdb"
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.servers.id
    nat                = true
    nat_ip_address     = yandex_vpc_address.external-ip-docker.external_ipv4_address.0.address
    security_group_ids = [yandex_vpc_security_group.docker_sg.id]
  }

  # Метаданные машины:
  # здесь можно указать скрипт, который запустится при создании ВМ или список SSH-ключей для доступа на ВМ
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    #ssh-keys = "ubuntu:${file("/root/.ssh/id_ed25519.pub")}"

    user-data = <<-EOF
      #cloud-config
      runcmd:
        - |
          # Ожидаем появления диска в системе
          # Для `device_name = "vdb"` устройство будет `/dev/vdb`
          DISK_DEVICE="/dev/vdb"
          MOUNT_POINT="/opt"

          # Форматируем диск в ext4 (будет выполнено только при первом запуске)
          if [ "$(blkid -o value -s TYPE $DISK_DEVICE 2>/dev/null)" != "ext4" ]; then
            mkfs.ext4 -F $DISK_DEVICE
          fi

          # Создаем точку монтирования. Закомментировано так как /opt уже существует
          # mkdir -p $MOUNT_POINT

          # Монтируем диск
          mount $DISK_DEVICE $MOUNT_POINT

          # Добавляем в fstab для автоматического монтирования после перезагрузки
          echo "$DISK_DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
      EOF
  }

}
