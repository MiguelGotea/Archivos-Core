# PitayaCore — Mano de Hierro (Iron Sync v13.1)

Este repositorio es el **Orquestador Central** del ecosistema Pitaya (API, ERP, Talento). Su función es actuar como la única Fuente de Verdad y garantizar la propagación absoluta de cambios.

## 🛡️ Arquitectura Mano de Hierro (v13.1)

A diferencia de modelos anteriores basados en señales intermitentes, la **v13.1** utiliza un modelo de **Inyección Directa por Checksum**.

### Componentes Sincronizados:
- `/core`: Lógica de negocio y librerías globales.
- `/docs`: Estándares, arquitectura y manuales.
- `/.agent`: Inteligencia y Skills (AI) sincronizadas.

### Pilares de la v13.1:
1. **Orquestación Directa**: Cuando `PitayaCore` recibe un cambio, él mismo clona cada subdominio y les **inyecta** los archivos mediante un `git push` directo. Esto elimina fallos por pérdida de señales.
2. **Checksum Total (`-c`)**: El sistema compara los archivos por su **contenido real**, no por su fecha. Esto garantiza que cada coma se detecte y se actualice al 100%.
3. **Semáforo Determinista**: Si la inyección en cualquier subdominio falla, la acción global se pone en **ROJO**. Si está en Verde, la sincronización es físicamente certera.

---

## 🚀 Flujo de Trabajo (Certeza Total)

### 1. Cambio en el Maestro
Realiza los cambios en `PitayaCore` y súbelos:
```powershell
./PitayaCore/.scripts/gitpush.ps1
```
*Esto inyectará el cambio automáticamente en API, ERP y Talento.*

### 2. Cambio desde un Subdominio
Si trabajas en un repositorio hijo (ej: ERP) y necesitas que el cambio llegue a todos:
```powershell
./erp.batidospitaya.com/.scripts/gitpush.ps1
```
*El subdominio mandará el cambio al Maestro, y el Maestro lo repartirá a todos los demás.*

### 3. Sincronización Local
Para actualizar tus carpetas locales de trabajo en `VisualCode/`:
```powershell
./gitsync-local.ps1
```

---

## 💻 Cómo agregar un nuevo Subdominio (en 5 minutos)

Para integrar un nuevo repositorio al ecosistema:

1. **GitHub Secrets**: Configura `SYNC_TOKEN` y las credenciales de Hostinger (`HOSTINGER_HOST`, `HOSTINGER_USER`, `HOSTINGER_SSH_KEY` y `HOSTINGER_PATH`).
2. **Workflow de Despliegue**: Asegúrate de que tu `deploy-*.yml` incluya las carpetas `core/` y `docs/` en el `rsync` hacia Hostinger.
3. **Workflow de Propuesta**: Copia el archivo `.github/workflows/propose-core-update.yml` de un subdominio existente al nuevo para permitirle mandar cambios al Maestro.
4. **Registro en PitayaCore**: Agrega el nombre del nuevo repo a la lista `matrix` en `.github/workflows/sync-to-subdomains.yml` dentro de `PitayaCore`.

---

## 🛠️ Herramientas
- `PitayaCore/.scripts/gitpush.ps1`: El disparador de inyección global.
- `VisualCode/gitsync-local.ps1`: El sincronizador local de alta precisión.
- [**05_Guia_Instalacion_Nueva_PC.md**](docs/05_Guia_Instalacion_Nueva_PC.md): Guía detallada para configurar el ecosistema desde cero.
