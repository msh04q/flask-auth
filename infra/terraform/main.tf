terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
}

provider "twc" {
  token = var.twc_token
}

# Ищем Ubuntu 22.04
data "twc_os" "ubuntu" {
  name    = "ubuntu"
  version = "22.04"
}

# Конфигуратор для Амстердама (минимальные ресурсы)
data "twc_configurator" "ams" {
  location = "nl-1"
}

# Загружаем ваш SSH-ключ в Timeweb
resource "twc_ssh_key" "main" {
  name = "flask-auth-key"
  body = file(var.ssh_public_key_path)
}

# Создаём сервер
resource "twc_server" "app" {
  name  = "flask-auth-prod"
  os_id = data.twc_os.ubuntu.id

  # Привязываем SSH-ключ и отключаем пароль root
  ssh_keys_ids              = [twc_ssh_key.main.id]
  is_root_password_required = false

  # Амстердам
  availability_zone = "ams-1"

  configuration {
    configurator_id = data.twc_configurator.ams.id
    cpu             = 1
    ram             = 1024
    disk            = 1024 * 15 # 15GB
  }
}

# Создаём плавающий IP и сразу привязываем к серверу
resource "twc_floating_ip" "app_ip" {
  availability_zone = "ams-1"
  comment           = "Public IP for flask-auth"

  resource {
    type = "server"
    id   = twc_server.app.id
  }
}

output "server_ip" {
  value = twc_floating_ip.app_ip.ip
}