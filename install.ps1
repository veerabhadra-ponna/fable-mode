# fable-mode installer (Windows PowerShell / PowerShell 7+)
# Installs the fable-method skill for Claude Code, globally or per-project.
#
#   .\install.ps1              # global:  %USERPROFILE%\.claude\skills\fable-method
#   .\install.ps1 -Project .   # project: <path>\.claude\skills\fable-method
#   .\install.ps1 -Agents      # also append the method to AGENTS.md (for Codex,
#                              # Gemini CLI, Cursor, and other AGENTS.md-aware tools)
param(
    [string]$Project = "",
    [switch]$Agents
)
# Works from a checkout OR standalone (no clone) - standalone downloads the
# skill from GitHub raw:
#   irm https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.ps1 | iex
$ErrorActionPreference = "Stop"
$rawBase = "https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master"
$src = if ($PSScriptRoot) { Join-Path $PSScriptRoot "skills\fable-method\SKILL.md" } else { "" }
if (-not $src -or -not (Test-Path $src)) {
    Write-Host "No local checkout - downloading skill from $rawBase ..."
    $src = Join-Path ([System.IO.Path]::GetTempPath()) "fable-method-SKILL.md"
    try { Invoke-WebRequest -UseBasicParsing "$rawBase/skills/fable-method/SKILL.md" -OutFile $src }
    catch { Write-Error "Download failed ($($_.Exception.Message)) - check network or install from a git clone."; exit 1 }
}

if ($Project) {
    if (-not (Test-Path $Project)) { Write-Error "Project path not found: $Project"; exit 1 }
    $root = (Resolve-Path $Project).Path
    $dest = Join-Path $root ".claude\skills\fable-method"
} else {
    $root = $env:USERPROFILE
    $dest = Join-Path $env:USERPROFILE ".claude\skills\fable-method"
}
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item $src (Join-Path $dest "SKILL.md") -Force
Write-Host "Installed skill -> $dest\SKILL.md"

if ($Agents) {
    $agentsFile = Join-Path $root "AGENTS.md"
    $marker = "<!-- fable-method:start -->"
    $body = (Get-Content $src -Raw) -replace "(?s)^---.*?---\s*", ""   # strip frontmatter
    $block = "$marker`n$body`n<!-- fable-method:end -->"
    if ((Test-Path $agentsFile) -and (Get-Content $agentsFile -Raw) -match [regex]::Escape($marker)) {
        $existing = Get-Content $agentsFile -Raw
        $updated = [regex]::Replace($existing, "(?s)<!-- fable-method:start -->.*?<!-- fable-method:end -->", $block)
        Set-Content $agentsFile $updated -Encoding utf8
        Write-Host "Updated fable-method block in $agentsFile"
    } else {
        Add-Content $agentsFile "`n$block" -Encoding utf8
        Write-Host "Appended fable-method block to $agentsFile"
    }
}
Write-Host "Done. In Claude Code, the skill auto-triggers on non-trivial tasks; invoke explicitly with /fable-method."
