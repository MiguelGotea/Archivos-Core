# PitayaCore — Sistema de Sincronización Centralizada

Este repositorio actúa como la **"Fuente de Verdad" (Source of Truth)** para todos los archivos compartidos del ecosistema Pitaya. 

## 🏗️ Arquitectura del Sistema

El sistema utiliza **GitHub Actions** para mantener sincronizadas las carpetas críticas entre múltiples repositorios.

### Carpetas Sincronizadas:
- `/core`: Lógica de negocio, vendors (PHPMailer, QR, etc.), y herramientas globales.
- `/docs`: Documentación técnica y estándares del proyecto.
- `/.agent`: Configuraciones y skills para agentes de IA.

### Flujos de Trabajo:
1. **Push en PitayaCore**: Dispara el envío de cambios hacia todos los subdominios (ERP, API, Talento, etc.).
2. **Push en Subdominio**: Si se modifica algo dentro de `/core` en un subdominio, este propone el cambio a PitayaCore, el cual lo acepta y lo redistribuye a los demás repositorios.
3. **Control de Bucles**: El sistema detecta si el contenido es idéntico antes de commitear, evitando ciclos infinitos de sincronización.

---

## 🚀 Guía: Cómo agregar un nuevo Subdominio al Sistema

Si en el futuro creas un nuevo repositorio (ej. `tienda.batidospitaya.com`) y quieres que reciba el núcleo automáticamente, sigue estos pasos:

### 1. Preparar el nuevo Repositorio
- Crea el repositorio en GitHub.
- Configura los **Secrets** en `Settings > Secrets and variables > Actions`:
    - `SYNC_TOKEN`: Un Classic PAT con permisos de `repo` y `workflow`.
    - `HOSTINGER_SSH_KEY`, `HOSTINGER_USER`, `HOSTINGER_HOST`: Credenciales de SSH.
    - `HOSTINGER_PATH_NEW`: La ruta destino en el servidor.

### 2. Configurar el Workflow de Recepción
- Copia el archivo `.github/workflows/receive-core-sync.yml` de cualquier otro subdominio al nuevo repo.
- **Importante**: Ajusta el secret del path en el paso de deploy (ej: cambia `secrets.HOSTINGER_PATH_API` por el nuevo secret).

### 3. Configurar el Workflow para Proponer Cambios
- Copia el archivo `.github/workflows/propose-core-update.yml` al nuevo repo. No requiere cambios adicionales.

### 4. Ajustar el .gitignore
- Asegúrate de que el `.gitignore` del nuevo repo **no** bloquee las carpetas compartidas. 
- Deben estar permitidas:
  ```gitignore
  !/core/
  !/docs/
  !/.agent/
  ```

### 5. Dar de alta en PitayaCore
- En este repositorio (`PitayaCore`), edita el archivo `.github/workflows/sync-to-subdomains.yml`.
- Agrega el nombre del nuevo repositorio a la lista de la **matrix**:
  ```yaml
  matrix:
    repo:
      - "erp.batidospitaya"
      - "api.batidospitaya"
      - "talento.batidospitaya"
      - "NUEVO.REPO"  # <--- Agregarlo aquí
  ```

---

## 💻 Uso de Scripts Locales

Para facilitar el trabajo en el entorno local (`VisualCode/`), utiliza el script de despliegue:

### Actualizar TODO desde PitayaCore:
Desde la carpeta `PitayaCore/`, ejecuta:
```powershell
./.scripts/gitpush.ps1
```
Este script:
1. Sube tus cambios a GitHub.
2. **Espeja localmente** los archivos en tus carpetas de ERP, API y Talento de forma instantánea (usando `robocopy`), evitando los retrasos de la nube.

---

**Nota**: Este sistema está diseñado para que nunca tengas que copiar archivos a mano entre carpetas. Confía en el flujo de Git.
