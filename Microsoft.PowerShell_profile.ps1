<#
.SYNOPSIS
PowerShell Profile - Primary
#>

## Vars
$env:Editor = 'gvim'
$global:showP4Prompt = $false
$global:showP4Status4NonStream = $true

# NOTE: Autoload/after/.. is to be sourced LAST
$autoload = Join-Path $(split-path $profile) 'autoload'
$after = Join-Path $autoload 'after'

## autoload/..
gci $autoload -Exclude after,persistenthistory.ps1 | gci -File -Recurse -Filter *.ps1  | % {
	. $_.FullName
}


#region INPUT
Set-PSReadlineOption -EditMode vi -BellStyle None
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# When using PSFZF, these key handlers must be removed BEFORE importing the module
Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadLineKeyHandler 'Alt+c'

Import-Module PSFZF
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -PSReadlineChordProvider 'Alt+c'
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -EnableAliasFuzzyEdit
Set-PsFzfOption -EnableAliasFuzzyHistory
Set-PsFzfOption -EnableAliasFuzzyKillProcess
Set-PsFzfOption -EnableAliasFuzzySetLocation
Set-PsFzfOption -EnableAliasFuzzySetEverything
Set-PsFzfOption -EnableAliasFuzzyZLocation
Set-PsFzfOption -EnableAliasFuzzyGitStatus

Import-Module Get-ChildItemColor
Import-Module zlocation
Import-Module cd-extras
Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:Home}" 'Source') -ErrorAction SilentlyContinue
#endregion


$global:goutils = 'C:\p4\nferguson_NF7590_DevOps_MAIN_8842\GoCD\GoUtils\GoUtils.psd1'
