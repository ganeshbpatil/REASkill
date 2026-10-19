<#
.SYNOPSIS  Scaffold investigations/YYYY-MM-<slug> from _template.
.EXAMPLE   .\scripts\New-Investigation.ps1 -Slug competitor-x -Hours 8
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9-]+$')][string]$Slug,
    [int]$Hours = 8,
    [string]$Owner = $env:USERNAME
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$id   = '{0}-{1}' -f (Get-Date -Format 'yyyy-MM'), $Slug
$dir  = Join-Path $root "investigations\$id"
if (Test-Path -LiteralPath $dir) { throw "Already exists: $dir" }

Copy-Item -Recurse -LiteralPath (Join-Path $root 'investigations\_template') -Destination $dir
Get-ChildItem -LiteralPath $dir -Recurse -Filter *.md | ForEach-Object {
    (Get-Content -LiteralPath $_.FullName -Raw) `
        -replace '\{\{ID\}\}', $id `
        -replace '\{\{OWNER\}\}', $Owner `
        -replace '\{\{DATE\}\}', (Get-Date -Format 'yyyy-MM-dd') `
        -replace '\{\{HOURS\}\}', $Hours |
        Set-Content -LiteralPath $_.FullName -Encoding utf8 -NoNewline
}
Write-Host "Created $dir. Fill in brief.md before running any analysis."
