# gitpush.ps1 - PitayaCore (Fuente de Verdad - Descentralizado)
# Script para actualizar el núcleo. No sincroniza localmente para evitar sobrescribir otros trabajos.

Write-Host "Iniciando Push en PitayaCore (Fuente de Verdad)..." -ForegroundColor Cyan

# 1. Paso: Actualizar PitayaCore en GitHub
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "chore(core): update core files $timestamp"
Write-Host "Sincronizando con GitHub..." -ForegroundColor Yellow
git pull origin main --rebase
git push origin main
Write-Host "[OK] PitayaCore actualizado en la nube." -ForegroundColor Green

# 2. Paso: Instrucciones para local
Write-Host "`n[INFO] Para actualizar tus otras carpetas locales, usa 'gitsync-local.ps1' en la raíz una vez que GitHub termine su sync." -ForegroundColor Yellow
