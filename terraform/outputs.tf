output "url" {
  description = "URL local para ejecutar una solicitud GET."
  value       = "http://127.0.0.1:${var.external_port}"
}

output "container_name" {
  value = docker_container.api.name
}

output "network_name" {
  value = docker_network.project.name
}

output "image_id" {
  value = docker_image.api.image_id
}
