output "container_name" {
  description = "Nombre del contenedor de la API."
  value       = docker_container.api.name
}

output "image_id" {
  description = "Identificador de la imagen descargada."
  value       = docker_image.api.image_id
}
