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
Set-Alias -Name frg -Value Invoke-FuzzyRgEdit
Set-Alias -Name fp4 -Value Invoke-FuzzyP4Client
Set-ALias -Name fcode -Value Invoke-FuzzyCodeWorkspace


# FZF
Set-Alias -Name cde -Value Set-LocationFuzzyEverything
Set-Alias -Name fz -Value Invoke-FuzzyZLocation
Set-Alias -Name fe -Value Invoke-FuzzyEdit
Set-Alias -Name fd -Value Invoke-FuzzySetLocation
Set-Alias -Name fh -Value Invoke-FuzzyHistory
Set-Alias -Name fkill -Value Invoke-FuzzyKillProcess
Set-Alias -Name fgs -Value Invoke-FuzzyGitStatus
