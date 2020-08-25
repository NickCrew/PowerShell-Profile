<#
.SYNOPSIS
PowerShell 7 Profile - Primary
#>

$global:goutils = 'C:\p4\nferguson_NF7590_DevOps_MAIN_8842\GoCD\GoUtils\GoUtils.psd1'

$shared = Join-path $(split-path $profile) 'Shared'

gci "${shared}\Autoload" -exclude after -Filter *.ps1 -Recurse | % {
    . $_.FullName
}

gci "${shared}\Autoload\After"  -Filter *.ps1 -Recurse | % {
    . $_.FullName
}
