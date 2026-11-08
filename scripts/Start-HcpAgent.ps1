param(
    [string]$AgentImage = 'hashicorp/tfc-agent:latest',
    [string]$AgentName = 'jvp-p11-agent'
)

$ErrorActionPreference = 'Stop'
$dockerCommand = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerCommand) {
    $dockerExe = $dockerCommand.Source
} else {
    $dockerExe = Join-Path $env:LOCALAPPDATA 'Programs/DockerDesktop/resources/bin/docker.exe'
    if (-not (Test-Path -LiteralPath $dockerExe)) {
        $dockerExe = Join-Path $env:ProgramFiles 'Docker/Docker/resources/bin/docker.exe'
    }
}
if (-not (Test-Path -LiteralPath $dockerExe)) { throw 'No se encontro docker.exe.' }

$engineOs = & $dockerExe info --format '{{.OSType}}'
if ($LASTEXITCODE -ne 0 -or $engineOs -ne 'linux') { throw 'Inicia Docker Desktop con contenedores Linux.' }
$existing = & $dockerExe ps -a --filter "name=^/$AgentName`$" --format '{{.Names}}'
if ($LASTEXITCODE -ne 0) { throw 'No se pudo consultar Docker.' }
if ($existing) { throw "El contenedor $AgentName ya existe. Revisa sus logs o reinicialo desde Docker Desktop." }

& $dockerExe pull $AgentImage
if ($LASTEXITCODE -ne 0) { throw 'No se pudo descargar la imagen oficial del agente.' }

# Usa el grupo del socket, sin cambiar sus permisos ni ejecutar el agente como root.
$socketGroup = & $dockerExe run --rm --entrypoint /bin/sh --mount 'type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock' $AgentImage -c 'stat -c %g /var/run/docker.sock'
if ($LASTEXITCODE -ne 0 -or "$socketGroup" -notmatch '^\d+$') { throw 'No se pudo consultar el grupo del socket Docker.' }

$secureToken = Read-Host 'Pega el token del agent pool de HCP (entrada oculta)' -AsSecureString
$tokenPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
$previousToken = $env:TFC_AGENT_TOKEN
try {
    $env:TFC_AGENT_TOKEN = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenPointer)
    if ([string]::IsNullOrWhiteSpace($env:TFC_AGENT_TOKEN)) { throw 'El token esta vacio.' }
    & $dockerExe run -d --name $AgentName --restart unless-stopped --group-add "$socketGroup" --mount 'type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock' --env TFC_AGENT_TOKEN --env "TFC_AGENT_NAME=$AgentName" $AgentImage
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo iniciar el agente.' }
} finally {
    $env:TFC_AGENT_TOKEN = $previousToken
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenPointer)
    $secureToken.Dispose()
}

Write-Host 'Agente iniciado. Revisa que aparezca conectado/Idle en HCP.'
& $dockerExe logs --tail 20 $AgentName
Write-Host 'El token queda en la configuracion privada del contenedor. No compartas docker inspect ni capturas del token.'
