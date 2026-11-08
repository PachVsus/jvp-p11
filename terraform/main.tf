module "network" {
  source = "./modules/network"

  project_name = var.project_name
}

module "api" {
  source = "./modules/api"

  project_name  = var.project_name
  external_port = var.external_port
  network_name  = module.network.name
  # La API incluye la identificacion de Tarea 8 para verificar el despliegue VCS.
  server_content = file("${path.module}/../app/server.py")
}
