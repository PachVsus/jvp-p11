terraform {
  required_version = ">= 1.6.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.6.0"
    }
  }
}

provider "docker" {
  context = var.docker_context
  host    = var.docker_context == null ? "unix:///var/run/docker.sock" : null
}
