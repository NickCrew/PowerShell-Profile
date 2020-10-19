<#
.SYNOPSIS
PowerShell 7 Profile - Primary
#>

$env:VMWARE_HOME = Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation'
$env:P4_ROOTDIR = 'C:\p4'

$global:goutils = 'C:\p4\nferguson_NF7590_DevOps_MAIN_8842\GoCD\GoUtils\GoUtils.psd1'

$shared = Join-path $(split-path $profile) 'Shared'

gci "${shared}\Autoload" -exclude after -Filter *.ps1 -Recurse | % {
    . $_.FullName
}

gci "${shared}\Autoload\After"  -Filter *.ps1 -Recurse | % {
    . $_.FullName
}
Import-Module oh-my-posh
Set-Theme pure

