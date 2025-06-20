
# SystemOptimizer.ps1 (v2) - Governance Enhancements
# Requires -RunAsAdministrator

param(
    [switch]$RevertChanges
)

# --- Privilege Check (Governance #1) ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run with elevated privileges. Right‑click PowerShell and choose 'Run as administrator'."
    exit 1
}

$ErrorActionPreference = "Stop"
$LogFile = "$env:USERPROFILE\Desktop\SystemOptimizer.log"
Start-Transcript -Path $LogFile -Append

function Create-RestorePoint {
    try {
        $description = "Pre-Optimization_" + (Get-Date -Format "yyyyMMdd_HHmmss")
        Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS"
        Write-Host "✓ Created system restore point: $description" -ForegroundColor Green
    } catch {
        # --- Restore‑Point Failure Path (Governance #3) ---
        Write-Warning "Unable to create a system restore point. Continuing without restore point; changes will NOT be automatically reversible."
    }
}

function Optimize-VisualEffects {
    Write-Host "`nOptimizing visual effects..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
    $keepEnabled = @("EnablePeek","SaveTaskbarThumbnails","ShowThumbnails","ShowTranslucentSelection","SmoothFonts")
    $effectsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    if (-not (Test-Path $effectsPath)) { New-Item -Path $effectsPath -Force | Out-Null }
    Get-ChildItem -Path $effectsPath | Remove-ItemProperty -Name "Applied" -ErrorAction SilentlyContinue
    foreach ($effect in $keepEnabled) {
        Set-ItemProperty -Path $effectsPath -Name $effect -Value 1 -Type DWord -ErrorAction SilentlyContinue
    }
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer.exe  # Relaunch explorer
    Write-Host "✓ Visual effects optimized (essential features retained)" -ForegroundColor Green
}

function Clean-TemporaryFiles {
    Write-Host "`nCleaning temporary files..." -ForegroundColor Cyan
    $targets = @(
        "$env:TEMP\*",
        "C:\Windows\Temp\*",
        "$env:LOCALAPPDATA\Temp\*",
        "$env:ProgramData\Microsoft\Windows\WER\ReportQueue\*",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
        "C:\`$Recycle.Bin\*"
    )
    foreach ($target in $targets) {
        try {
            if (Test-Path $target) {
                Remove-Item -Path $target -Recurse -Force -ErrorAction Stop
                Write-Host "✓ Cleaned: $target" -ForegroundColor DarkGray
            }
        } catch { Write-Warning "Skipped $target (in use or protected)" }
    }
}

function Disable-UnnecessaryServices {
    Write-Host "`nDisabling unnecessary services..." -ForegroundColor Cyan
    $servicesToDisable = @("DiagTrack","MapsBroker")
    foreach ($svc in $servicesToDisable) {
        try {
            Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "✓ Disabled service: $svc" -ForegroundColor Yellow
        } catch { Write-Warning "Failed to disable $svc" }
    }
}

if ($RevertChanges) {
    Write-Host "`nRevert option selected. Reversion logic not yet implemented in this version." -ForegroundColor Red
    Stop-Transcript
    exit
}

Write-Host "`n===== SYSTEM OPTIMIZATION STARTED =====" -ForegroundColor Magenta
Create-RestorePoint
Optimize-VisualEffects
Clean-TemporaryFiles
Disable-UnnecessaryServices
Write-Host "`n===== SYSTEM OPTIMIZATION COMPLETED SUCCESSFULLY =====" -ForegroundColor Green
Write-Host "Log saved to: $LogFile" -ForegroundColor Cyan

Stop-Transcript
