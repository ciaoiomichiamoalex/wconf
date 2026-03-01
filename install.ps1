# install.ps1
# Creates symbolic links for all configuration files in this repository.
# Requires Administrator privileges or Windows Developer Mode enabled.
#
# Usage: .\install.ps1

# Requires -Version 5.1

$repo = $PSScriptRoot

# Map: source path (relative to repo) => destination path (absolute)
$links = @(
    @{ Src = "terminal\settings.json";                        Dst = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" },
    @{ Src = ".gitconfig";                                    Dst = "$env:USERPROFILE\.gitconfig" },
    @{ Src = ".pylintrc";                                     Dst = "$env:USERPROFILE\.pylintrc" },
    @{ Src = "omp.json";                                      Dst = "$env:USERPROFILE\omp.json" },
    @{ Src = "terminal\Microsoft.PowerShell_profile.ps1";     Dst = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" },
    @{ Src = "postgresql\pgpass.conf";                        Dst = "$env:APPDATA\PostgreSQL\pgpass.conf" },
    @{ Src = "claude\settings.json";                          Dst = "$env:USERPROFILE\.claude\settings.json" },
    @{ Src = "claude\CLAUDE.md";                              Dst = "$env:USERPROFILE\.claude\CLAUDE.md" },
    @{ Src = "claude\statusbar.sh";                           Dst = "$env:USERPROFILE\.claude\statusbar.sh" }
)

# Add all files from sublime_text\ dynamically
Get-ChildItem -Path "$repo\sublime_text" -File | ForEach-Object {
    $links += @{ Src = "sublime_text\$($_.Name)"; Dst = "$env:APPDATA\Sublime Text\Packages\User\$($_.Name)" }
}

function New-Symlink {
    param([string]$Source, [string]$Target)

    # Ensure parent directory exists
    $parent = Split-Path -Parent $Target
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Write-Host "    mkdir $parent" -ForegroundColor DarkGray
    }

    # Backup any existing file or symlink
    if (Test-Path -LiteralPath $Target) {
        $backup = "$Target.bak"
        Move-Item -LiteralPath $Target -Destination $backup -Force
        Write-Host "    bak  $(Split-Path -Leaf $Target) => $(Split-Path -Leaf $backup)" -ForegroundColor Yellow
    }

    New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force | Out-Null
    Write-Host "    link $Target" -ForegroundColor Green
}

# Warn if not running as admin (symlinks may require elevation)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $isAdmin) {
    Write-Warning "Not running as Administrator. Symlink creation may fail unless Windows Developer Mode is enabled."
}

foreach ($link in $links) {
    $src = Join-Path $repo $link.Src
    $dst = $link.Dst

    Write-Host "`n$($link.Src)"

    if (-not (Test-Path -LiteralPath $src)) {
        Write-Warning "Source not found, skipping: $src"
        continue
    }

    New-Symlink -Source $src -Target $dst
}

Write-Host "`nDone." -ForegroundColor Cyan
