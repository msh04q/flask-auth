variable "twc_token" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/nl_server.pub" # Убедитесь, что путь верный
}