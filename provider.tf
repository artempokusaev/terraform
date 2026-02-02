terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.92"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    bucket   = "new-tfstate"
    key      = "terraform.tfstate"
    region   = "ru-central1"
    endpoint = "https://storage.yandexcloud.net"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}