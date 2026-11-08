# Conserva las direcciones del estado al actualizar una instalacion existente.
moved {
  from = docker_network.project
  to   = module.network.docker_network.project
}

moved {
  from = docker_image.api
  to   = module.api.docker_image.api
}

moved {
  from = docker_container.api
  to   = module.api.docker_container.api
}
