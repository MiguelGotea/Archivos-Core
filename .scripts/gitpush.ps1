# gitpush.ps1 - PitayaCore (Fuente de Verdad + Sync Local Quirúrgico)
# Script para actualizar el núcleo y sincronizar automáticamente todos los subdominios locales.

Write-Host "Iniciando Push en PitayaCore (Fuente de Verdad)..." -ForegroundColor Cyan

# 1. Paso: Actualizar PitayaCore en GitHub
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "chore(core): update core files $timestamp"
Write-Host "Sincronizando con cambios remotos de PitayaCore..." -ForegroundColor Yellow
git pull origin main --rebase
git push origin main
Write-Host "[OK] PitayaCore actualizado y sincronización en la nube disparada." -ForegroundColor Green

# 2. Paso: Sincronización Local Quirúrgica de Subdominios
# Nota: Esto trae los cambios de GitHub. Requiere que el Action de la nube haya terminado.
Write-Host "`nSincronizando copias locales de subdominios..." -ForegroundColor Cyan

$subdominios = @(
    "..\api.batidospitaya.com",
    "..\erp.batidospitaya.com",
    "..\talento.batidospitaya.com"
)

foreach ($repo in $subdominios) {
    if (Test-Path $repo) {
        Write-Host "`n--- Actualizando $repo ---" -ForegroundColor Yellow
        Set-Location $repo
        
        # Traer metadatos de GitHub
        git fetch origin main
        
        # Actualizar ÚNICAMENTE las 3 carpetas compartidas
        git checkout origin/main -- core/
        git checkout origin/main -- docs/
        git checkout origin/main -- .agent/
        
        Set-Location "..\PitayaCore"
    }
}

Write-Host "`n[OK] Procedimiento completo finalizado." -ForegroundColor Green
