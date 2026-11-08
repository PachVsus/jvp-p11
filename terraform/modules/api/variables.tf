variable "project_name" {
  description = "Prefijo del contenedor y etiqueta del proyecto."
  type        = string
}

variable "external_port" {
  description = "Puerto publicado en la interfaz local del equipo Docker."
  type        = number
  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535 && floor(var.external_port) == var.external_port
    error_message = "Usa un puerto entero entre 1024 y 65535."
  }
}

variable "network_name" {
  description = "Red Docker creada por el modulo network."
  type        = string
}

variable "server_content" {
  description = "Contenido del servidor Python que se copia al contenedor."
  type        = string
}
