# fable-mode installer (Windows PowerShell 5.1 / PowerShell 7+)
# Installs the fable-method skill (+ bundled rules) for Claude Code.
#
#   .\install.ps1              # global:  %USERPROFILE%\.claude\skills\fable-method
#   .\install.ps1 -Project .   # project: <path>\.claude\skills\fable-method
#   .\install.ps1 -Agents      # also write the method into AGENTS.md (for Codex,
#                              # Gemini CLI, Cursor, and other AGENTS.md-aware tools)
#
# Works from a checkout OR standalone (no clone):
#   irm https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.ps1 | iex
param(
    [string]$Project = "",
    [switch]$Agents
)
$ErrorActionPreference = "Stop"
$rawBase = "https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master"
$rules = @("model-routing.md", "self-steering.md", "skill-evolution.md")

if ($Project) {
    if (-not (Test-Path $Project)) { throw "Project path not found: $Project" }
    $root = (Resolve-Path $Project).Path
} else {
    $root = $env:USERPROFILE
}
$dest = Join-Path $root ".claude\skills\fable-method"
New-Item -ItemType Directory -Force (Join-Path $dest "references") | Out-Null

$localSkill = if ($PSScriptRoot) { Join-Path $PSScriptRoot "skills\fable-method\SKILL.md" } else { "" }
if ($localSkill -and (Test-Path $localSkill)) {
    Copy-Item $localSkill (Join-Path $dest "SKILL.md") -Force
    foreach ($r in $rules) { Copy-Item (Join-Path $PSScriptRoot "rules\$r") (Join-Path $dest "references\$r") -Force }
} else {
    Write-Host "No local checkout - downloading from $rawBase ..."
    try {
        Invoke-WebRequest -UseBasicParsing "$rawBase/skills/fable-method/SKILL.md" -OutFile (Join-Path $dest "SKILL.md")
        foreach ($r in $rules) { Invoke-WebRequest -UseBasicParsing "$rawBase/rules/$r" -OutFile (Join-Path $dest "references\$r") }
    } catch { throw "Download failed ($($_.Exception.Message)) - check network or install from a git clone." }
}
Write-Host "Installed skill -> $dest"

if ($Agents) {
    $agentsFile = Join-Path $root "AGENTS.md"
    $markerStart = "<!-- fable-method:start -->"
    $markerEnd = "<!-- fable-method:end -->"
    $raw = [System.IO.File]::ReadAllText((Join-Path $dest "SKILL.md")) -replace "`r", ""
    $body = [regex]::Replace($raw, "(?s)^---.*?---\s*", "")
    $block = "$markerStart`n$body`n$markerEnd"
    $kept = ""
    if (Test-Path $agentsFile) {
        $existing = [System.IO.File]::ReadAllText($agentsFile) -replace "`r", ""
        $pattern = "(?s)" + [regex]::Escape($markerStart) + ".*?" + [regex]::Escape($markerEnd)
        $kept = ([regex]::Replace($existing, $pattern, "")).TrimEnd()
    }
    $out = if ($kept) { "$kept`n`n$block`n" } else { "$block`n" }
    # WriteAllText default = UTF-8 without BOM
    [System.IO.File]::WriteAllText($agentsFile, $out)
    Write-Host "Wrote fable-method block to $agentsFile"
}
Write-Host "Done. In Claude Code, the skill auto-triggers on non-trivial tasks; invoke explicitly with /fable-method."
