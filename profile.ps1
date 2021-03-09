# #####################################################
#
# Name: profile.ps1
# Profile: CurrentUserAllHosts
# PSVersion: 7
#
# Profile Load Order: 
#     - AllUsersAllHosts
#     - AllUsersCurrentHost 
#     - CurrentUserAllHosts 
#     - CurrentUserCurrentHost
#
# #####################################################

# PSReadline
Set-PSReadlineOption -EditMode vi 
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

. "${PSScriptRoot}/Functions.ps1"

Set-Alias -Name co -Value code-insiders.cmd -Force

# this could go in CurrentUserCurrentHost but I like having it in VSCode terminal
Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadLineKeyHandler 'Alt+c'
Import-Module PSFZF

# replace standard tab completion with FZF completion
#Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

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
