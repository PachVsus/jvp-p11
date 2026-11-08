output "name" {
  description = "Nombre de la red para conectar contenedores."
  value       = docker_network.project.name
}
