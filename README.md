# Practica 11 y Tarea 8: Terraform Modules y HCP

Proyecto Docker refactorizado en dos modulos locales. HCP Terraform ejecuta los planes y applies mediante un agente en Docker Desktop; los recursos se crean en este equipo.

## Estructura

```text
app/server.py
scripts/Start-HcpAgent.ps1
terraform/
  main.tf                 # Llama a los modulos network y api
  variables.tf            # Entradas de la raiz
  outputs.tf              # Salidas de los modulos
  versions.tf             # Proveedor Docker
  moved.tf                # Migracion de direcciones previas
  modules/
    network/              # Red Docker y salida name
    api/                  # Imagen Python y contenedor GET
```

## Configurar HCP

1. En la organizacion jesvagp_iteso_org, abre Settings > Agents > Create agent pool. Nombre: jvp-p11-pool.
2. Crea un token con descripcion jvp-p11-agent. Copialo; HCP lo muestra una sola vez. No lo publiques ni lo agregues a Git.
3. En PowerShell, desde C:\jvp-p11, ejecuta `./scripts/Start-HcpAgent.ps1`. Cuando lo solicite, pega el token en la entrada oculta. El agente tendra acceso al motor Docker para administrar los recursos. El script mantiene el usuario no root y agrega el grupo del socket.
4. Verifica que el agente aparezca Idle en HCP. La disponibilidad de agentes depende del plan de tu organizacion. Si solicita contratar un plan, revisa esa limitacion antes de continuar.
5. Si hay una opcion para limitar el pool, permite solamente el workspace jvp-p11.
6. En el workspace jvp-p11, Settings > General: selecciona Agent como Execution Mode y el pool jvp-p11-pool. Guarda. No debe haber un run pendiente de apply al cambiar el modo.
7. Conserva Terraform Working Directory = terraform y Auto-apply desactivado.
8. Variables Terraform: project_name = jvp-p11 (HCL desactivado), external_port = 8080 (HCL activado). Ninguna es Sensitive. No agregues docker_context en HCP: su valor predeterminado null permite usar el socket Linux.
9. Para un workspace sin runs, inicia el primer run manualmente con Start new plan. HCP requiere este primer run antes de aceptar disparadores VCS. Verifica que use el commit esperado.
10. Revisa el plan: 3 to add, 0 to change, 0 to destroy para un workspace nuevo sin estado. Confirma Apply en HCP y espera Apply Finished.
11. Sube un cambio posterior a la rama main de GitHub para generar un run VCS. Los cambios en server_content reemplazan solo el contenedor; revisa el plan y confirma Apply en HCP.
12. Abre http://127.0.0.1:8080 en este equipo. La respuesta actualizada debe incluir mensaje Hola desde Terraform Modules y HCP, tarea 8 y modulos network y api.

Para disparar futuros runs cuando solo cambie app/server.py, incluye app/** junto con terraform/** en los patrones de Automatic Run Triggering de Settings > Version Control. Este archivo esta fuera del directorio terraform.

No ejecutes apply local mientras HCP administra estos mismos recursos: cada estado podria intentar administrar los mismos nombres.

## Verificacion local sin aplicar

```powershell
terraform -chdir=terraform init
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform validate
terraform -chdir=terraform plan -var="docker_context=desktop-linux"
```

## Evidencias de la tarea

- Captura del run VCS con Apply Finished en HCP, incluyendo el resumen de recursos.
- Captura de VS Code con terraform/modules expandido y terraform/main.tf abierto.
- Captura de la pestana Overview del modulo si el docente requiere su publicacion en el registro privado de HCP. Los modulos locales no aparecen automaticamente en Registry; publicar un modulo requiere un repositorio de modulo y configuracion adicional.
- Captura adicional del workspace Overview con recursos y del GET local, si resulta util.

Los archivos en evidencias/ corresponden a la practica anterior. No representan un apply de HCP de esta tarea.

## Agente

El script usa la imagen oficial hashicorp/tfc-agent. El token se introduce como SecureString y se pasa mediante el entorno del proceso; no se escribe a un archivo del repositorio. Docker conserva el token en la configuracion del contenedor, por lo que no compartas la salida de docker inspect. Mantener Docker Desktop encendido permite que el agente reciba los runs.

Para detener el agente al terminar, usa Stop sobre jvp-p11-agent en Docker Desktop. Antes de destruir recursos, ejecuta y revisa un Destroy run en el workspace de HCP que los administra.

## Referencias

- https://developer.hashicorp.com/terraform/cloud-docs/agents/agent-pools
- https://developer.hashicorp.com/terraform/cloud-docs/agents/agents
- https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-agents
