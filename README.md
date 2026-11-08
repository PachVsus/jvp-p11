# Práctica 11: Terraform con Docker

Adaptación local solicitada, sin Azure ni credenciales de nube.

## Alcance

La captura tiene instrucciones de Cloudflare (Worker, D1 y subdominio), pero su rúbrica pide Docker. Este proyecto sigue la opción Docker: Terraform descarga y administra una imagen Python, crea un contenedor con un script GET y una red con etiquetas para organizar los recursos. No construye una imagen personalizada ni crea recursos de Azure o Cloudflare. Docker no tiene un recurso equivalente al grupo de recursos de Azure; la red y la etiqueta project sirven como organización local. Esta adaptación debe ser aceptada por el docente si exige literalmente Cloudflare.

## Archivos

- terraform/versions.tf: versiones y proveedor Docker.
- terraform/variables.tf: nombre del proyecto y puerto local.
- terraform/main.tf: imagen, red y contenedor.
- terraform/outputs.tf: URL y nombres de recursos.
- app/server.py: servidor HTTP GET con respuesta JSON.
- evidencias/: salidas reales de las ejecuciones.

## Ejecución en PowerShell

Requiere Docker Desktop iniciado con contenedores Linux y contexto desktop-linux, Terraform y acceso a Internet para descargar proveedor e imagen.

```powershell
Set-Location C:\jvp-p11\terraform
terraform init
terraform fmt -check
terraform validate
terraform plan -out="practica.tfplan"
terraform apply practica.tfplan
Invoke-RestMethod http://127.0.0.1:8080
docker ps --filter label=project=jvp-p11
docker network ls --filter label=project=jvp-p11
terraform plan
```

El último plan debe indicar que no hay cambios. El servicio se publica solo en la interfaz local 127.0.0.1.

## Destrucción

Después de guardar las evidencias, elimina los recursos administrados por esta práctica:

```powershell
Set-Location C:\jvp-p11\terraform
terraform plan -destroy -out="destruir.tfplan"
terraform apply destruir.tfplan
terraform state list
docker ps -a --filter label=project=jvp-p11
docker network ls --filter label=project=jvp-p11
```

Se eliminan el contenedor, la red y la imagen administrada por Terraform. No se ejecuta docker system prune. Los archivos del proyecto y las evidencias permanecen. Conserva .terraform.lock.hcl para fijar el proveedor; no publiques estados ni planes.

## Referencias

- https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build
- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs

