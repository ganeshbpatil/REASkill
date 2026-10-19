<#
.SYNOPSIS  Copy a file into targets/, hash it, mark it read-only, and append to MANIFEST.csv.
.EXAMPLE   .\scripts\Add-Target.ps1 -Path D:\x.apk -Source "Play Store v4.2.1" -Basis "competitive behaviour analysis"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$Basis,
    [ValidateSet('yes','no','unknown')][string]$EulaForbidsRe = 'unknown',
    [string]$Notes = ''
)
$ErrorActionPreference = 'Stop'
$root     = Split-Path $PSScriptRoot -Parent
$targets  = Join-Path $root 'targets'
$manifest = Join-Path $targets 'MANIFEST.csv'

$src  = Get-Item -LiteralPath $Path
$dest = Join-Path $targets $src.Name
if (Test-Path -LiteralPath $dest) { throw "Target already exists: $dest" }

Copy-Item -LiteralPath $src.FullName -Destination $dest
$hash = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash.ToLower()
Set-ItemProperty -LiteralPath $dest -Name IsReadOnly -Value $true

[pscustomobject]@{
    file            = $src.Name
    sha256          = $hash
    size_bytes      = $src.Length
    source          = $Source
    acquired_utc    = (Get-Date).ToUniversalTime().ToString('s') + 'Z'
    basis           = $Basis
    eula_forbids_re = $EulaForbidsRe
    notes           = $Notes
} | Export-Csv -LiteralPath $manifest -Append -NoTypeInformation -Encoding utf8

Write-Host "Added $($src.Name)  sha256=$hash"
if ($EulaForbidsRe -ne 'no') { Write-Warning "EULA status '$EulaForbidsRe': brief.md needs sign-off before analysis (CLAUDE.md §0)." }
