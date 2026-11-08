# Modulo api

Descarga `python:3.13-slim` y crea un contenedor que ejecuta un servidor GET.
Publica el puerto 8000 del contenedor solamente en `127.0.0.1` del equipo Docker.

| Entrada | Tipo | Uso |
| --- | --- | --- |
| project_name | string | Prefijo del contenedor y etiqueta project |
| external_port | number | Puerto local entre 1024 y 65535 |
| network_name | string | Red entregada por el modulo network |
| server_content | string | Codigo Python para copiar a /app/server.py |

Salidas: `container_name`, `image_id`.

El proveedor Docker se configura en la raiz y se hereda. Este modulo no requiere credenciales de nube.
