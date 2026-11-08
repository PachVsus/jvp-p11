resource "docker_image" "api" {
  name         = "python:3.13-slim"
  keep_locally = false
}

resource "docker_container" "api" {
  name    = "${var.project_name}-api"
  image   = docker_image.api.image_id
  command = ["python", "-u", "/app/server.py"]
  user    = "10001:10001"

  upload {
    content = var.server_content
    file    = "/app/server.py"
  }

  ports {
    internal = 8000
    external = var.external_port
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name = var.network_name
  }

  labels {
    label = "project"
    value = var.project_name
  }
}
