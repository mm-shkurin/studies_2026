# Import PlantUML folder into a Visual Paradigm .vpp via PlantUML-VP plugin CLI.
# Requires: VP CE 18.1+, plugin in %APPDATA%\VisualParadigm\plugins\plugin-plantuml-vp
#
# Usage:
#   .\import-plantuml.ps1 -ProjectPath .\AirportDesign.vpp -PumlDir ..\diagrams
#   .\import-plantuml.ps1 -ProjectPath .\AirportDesign.vpp -PumlDir ..\diagrams -ExportPngDir .\png

param(
    [Parameter(Mandatory = $true)][string]$ProjectPath,
    [Parameter(Mandatory = $true)][string]$PumlDir,
    [string]$VpHome = "C:\Program Files\Visual Paradigm CE 18.1",
    [string]$ExportPngDir = ""
)

$ErrorActionPreference = "Stop"
$ProjectPath = (Resolve-Path $ProjectPath).Path
$PumlDir = (Resolve-Path $PumlDir).Path
$scripts = Join-Path $VpHome "scripts"
if (-not (Test-Path (Join-Path $scripts "Plugin.bat"))) {
    throw "Plugin.bat not found under $scripts"
}

$pluginDir = Join-Path $env:APPDATA "VisualParadigm\plugins\plugin-plantuml-vp\plugin.xml"
if (-not (Test-Path $pluginDir)) {
    throw "PlantUML plugin missing. Expected $pluginDir"
}

$env:HEADLESS = "true"
Push-Location $scripts
try {
    Write-Host "Importing $PumlDir -> $ProjectPath"
    & .\Plugin.bat -project $ProjectPath -pluginid "plugins.plantUML" -pluginargs -action "import" -path $PumlDir
    if ($LASTEXITCODE -ne 0) { throw "Plugin import failed with exit $LASTEXITCODE" }

    Write-Host "Listing diagrams:"
    & .\Plugin.bat -project $ProjectPath -pluginid "plugins.plantUML" -pluginargs -action "export" -list

    if ($ExportPngDir) {
        New-Item -ItemType Directory -Path $ExportPngDir -Force | Out-Null
        $ExportPngDir = (Resolve-Path $ExportPngDir).Path
        Write-Host "NOTE: CLI PNG often crops empty until layout is fixed in GUI."
        Write-Host "Open the .vpp in Visual Paradigm, accept Diagram Patched, then File > Export > Active Diagram as Image."
        Write-Host "Optional CLI attempt into $ExportPngDir (may be blank):"
        & .\Plugin.bat -project $ProjectPath -pluginid "plugins.plantUML" -pluginargs -action "export" -list |
            ForEach-Object {
                if ($_ -match '^\s*(.+?)\s*\|\s*id:') {
                    $name = $Matches[1].Trim()
                    $outFile = Join-Path $ExportPngDir ($name + ".png")
                    & .\ExportDiagramImage.bat -project $ProjectPath -out $outFile -diagram $name -type png
                }
            }
    }
}
finally {
    Pop-Location
}
