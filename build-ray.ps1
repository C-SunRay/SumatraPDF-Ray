$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
foreach ($tool in @('bun', 'cargo')) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { throw "Required tool missing from PATH: $tool" }
}
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path -LiteralPath $vswhere)) { throw 'Install Visual Studio C++ Build Tools first.' }
$msbuild = & $vswhere -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild\**\Bin\MSBuild.exe' | Select-Object -First 1
if (-not $msbuild) { throw 'MSBuild was not found.' }
& .\bin\MakeLZSA.exe translations\translations.txt.lzsa translations\translations-good.txt:translations-good.txt
if ($LASTEXITCODE -ne 0) { throw 'Translation archive generation failed.' }
& $msbuild vs2022\SumatraPDF.sln /t:SumatraPDF '/p:Configuration=Release;Platform=x64' /m:4 /verbosity:minimal /nologo
if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
Write-Host 'Built out/rel64/SumatraPDF-Ray.exe'
