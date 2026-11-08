module "network" {
  source = "./modules/network"

  project_name = var.project_name
}

module "api" {
  source = "./modules/api"

  project_name   = var.project_name
  external_port  = var.external_port
  network_name   = module.network.name
  server_content = file("${path.module}/../app/server.py")
}
