<#
.SYNOPSIS
PowerShell Aliases
#>

# Custom Functions
Set-Alias -Name sclip -Value Set-Clipboard
Set-Alias -name codework -Value Open-VSCodeWorkspace
Set-Alias -Name lsrepos -Value Find-GitRepos
Set-Alias -Name codei -Value Open-VSCodeInsiders
Set-Alias -Name setp4 -Value Set-P4Client


# FZF
Set-Alias -Name fz -Value Invoke-FuzzyZLocation
Set-Alias -Name fe -Value Invoke-FuzzyEdit
Set-Alias -Name fd -Value Invoke-FuzzySetLocation
