<#
.SYNOPSIS
PowerShell 7 Profile - Primary
#>

$env:VMWARE_HOME = Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation'
$env:P4_ROOTDIR = 'C:\p4'
$env:Editor = 'gvim'

$shared = Join-path $(split-path $profile) 'Shared'


gci "${shared}\Autoload" -exclude after -Filter *.ps1 -Recurse | % {
    . $_.FullName
}

gci "${shared}\Autoload\After"  -Filter *.ps1 -Recurse | % {
    . $_.FullName
}


Import-Module posh-git
Import-Module oh-my-posh -RequiredVersion 2.0.487
Set-Theme pure
