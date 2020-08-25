# Initialize shared settings


$psdir =  Split-Path $PSScriptRoot -Parent
$shared = Join-Path $psdir 'Shared'
$autoload = Join-Path $shared 'Autoload'
$after = Join-Path $autoload 'After'
$modules = Join-Path $psdir 'Modules'

if (($env:PSModulePath -split ';') -notcontains $modules) {
    $env:PSModulePath = "${env:PSModulePath};${modules}"
}

    # Autoload
gci $autoload -Exclude after | gci -File -Recurse -Filter *.ps1  | % {
    . $_.FullName
}

# Autoload/After
gci $after -File -Recurse -Filter *.ps1 | % {
    . $_.FullName
}
