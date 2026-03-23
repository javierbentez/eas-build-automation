# ==============================================================================
# Script: Expo & EAS Build Automation (Windows Version)
# Description: Streamlines cleaning, installing, and building for Expo projects.
# ==============================================================================

# Configuración de codificación para iconos y colores
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funciones de utilidad para feedback visual
function Show-Info ($msg) { Write-Host "i $msg" -ForegroundColor Blue }
function Show-Success ($msg) { Write-Host "✓ $msg" -ForegroundColor Green }
function Show-Warning ($msg) { Write-Host "⚠️ $msg" -ForegroundColor Yellow }
function Show-Error ($msg) { Write-Host "✖ $msg" -ForegroundColor Red; exit }

Clear-Host
Write-Host "--- 🛠  BUILD CONFIGURATION ---" -Style Bold

# 1. Validación de dependencias
Show-Info "Checking required tools..."
if (!(Get-Command git -ErrorAction SilentlyContinue)) { Show-Error "Git is not installed." }
if (!(Get-Command npm -ErrorAction SilentlyContinue)) { Show-Error "Node/NPM is not installed." }
if (!(Get-Command eas -ErrorAction SilentlyContinue)) { Show-Error "EAS CLI is not installed. Run: npm install -g eas-cli" }

# 2. Configuración interactiva
# Selección de Plataforma
Write-Host "`nSelect target platform:" -ForegroundColor Cyan
$platforms = @("ios", "android", "all")
for ($i=0; $i -lt $platforms.Length; $i++) { Write-Host "$($i+1)) $($platforms[$i])" }
$platChoice = Read-Host "Choice"
$PLATFORM = $platforms[$platChoice - 1]

# Selección de Perfil
Write-Host "`nSelect build profile:" -ForegroundColor Cyan
$profiles = @("development", "preview", "production")
for ($i=0; $i -lt $profiles.Length; $i++) { Write-Host "$($i+1)) $($profiles[$i])" }
$profChoice = Read-Host "Choice"
$PROFILE = $profiles[$profChoice - 1]

# Selección de Tipo de Ejecución
Write-Host "`nWhere should the build run?" -ForegroundColor Cyan
Write-Host "1) Local (--local)"
Write-Host "2) Cloud (EAS Cloud)"
$typeChoice = Read-Host "Choice"
$BUILD_TYPE = if ($typeChoice -eq "1") { "local" } else { "cloud" }

# Validación de iOS local en Windows
if ($PLATFORM -eq "ios" -and $BUILD_TYPE -eq "local") {
    Show-Error "iOS local builds are not supported on Windows. Please use EAS Cloud for iOS."
}

Write-Host "`nSummary: $PLATFORM | Profile: $PROFILE | Engine: $BUILD_TYPE" -ForegroundColor DarkCyan

# 3. Gestión de Git
Show-Info "Syncing with remote repository..."
git pull
if ($LASTEXITCODE -ne 0) {
    Show-Warning "Conflicts or uncommitted local changes detected."
    $confirm = Read-Host "Do you want to DISCARD local changes (git checkout .) and continue? (y/n)"
    if ($confirm -eq "y") {
        git checkout .
        git pull
        Show-Success "Repository cleaned and updated."
    } else {
        Show-Error "Build aborted to protect your local work."
    }
}

# 4. Preparación del entorno
Show-Info "Installing dependencies (npm install)..."
npm install | Out-Null
Show-Success "Dependencies installed."

Show-Info "Running expo prebuild..."
npx expo prebuild --platform $PLATFORM --clean
Show-Success "Prebuild finished."

# 5. Ejecución del Build
Show-Info "Initializing EAS Build..."

$flags = "--platform $PLATFORM --profile $PROFILE --non-interactive"

if ($BUILD_TYPE -eq "local") {
    $flags += " --local"
}

if ($PROFILE -eq "production") {
    $flags += " --auto-submit"
    Show-Info "Production profile: --auto-submit enabled."
}

# Final Execution
Write-Host "Running: eas build $flags" -ForegroundColor Yellow
Invoke-Expression "eas build $flags"

Show-Success "Process completed successfully!"
