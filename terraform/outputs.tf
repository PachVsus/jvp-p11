output "url" {
  description = "URL local para ejecutar una solicitud GET."
  value       = "http://127.0.0.1:${var.external_port}"
}

output "container_name" {
  value = module.api.container_name
}

output "network_name" {
  value = module.network.name
}

output "image_id" {
  value = module.api.image_id
}
