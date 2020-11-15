<#
.SYNOPSIS
PowerShell 7 Profile - Primary
#>

$env:VMWARE_HOME = Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation'
$env:P4_ROOTDIR = 'C:\p4'
$env:Editor = 'gvim'


Set-PSReadlineOption -EditMode vi -BellStyle None
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$shared = Join-path $(split-path $profile) 'Shared'

Set-Variable -Name PSUserHome -Value ((Resolve-Path $PSScriptRoot).Path) -Option AllScope,ReadOnly -Force

. "${PSScriptRoot}/Shared/Prompts/git.prompt.ps1"

Get-ChildItem "${shared}\Autoload" -exclude after -Filter *.ps1 -Recurse | % {
    . $_.FullName
}

Get-ChildItem "${shared}\Autoload\After"  -Filter *.ps1 -Recurse | % {
    . $_.FullName
}
