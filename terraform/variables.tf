variable "docker_context" {
  description = "Contexto local en Windows. En el agente Linux se deja null para usar el socket Docker."
  type        = string
  default     = null
}

variable "project_name" {
  description = "Nombre para agrupar los recursos mediante red y etiquetas."
  type        = string
  default     = "jvp-p11"
}

variable "external_port" {
  description = "Puerto local para consultar el servicio GET."
  type        = number
  default     = 8080
  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535 && floor(var.external_port) == var.external_port
    error_message = "Usa un puerto entero entre 1024 y 65535."
  }
}
