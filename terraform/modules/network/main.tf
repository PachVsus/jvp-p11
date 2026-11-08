resource "docker_network" "project" {
  name = "${var.project_name}-network"

  labels {
    label = "project"
    value = var.project_name
  }
}
