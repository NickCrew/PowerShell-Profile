# Name: profile.ps1
# Profile: CurrentUserAllHosts
# Loads after: AllUsers, AllHosts
# Loads before: CurrentUserCurrentHost
# PSVersion: 7

# PSReadline
Set-PSReadlineOption -EditMode vi -BellStyle None
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Completion
TabExpansion2.ps1
Invoke-Build.ArgumentCompleters.ps1
gci "${PSScriptRoot}/Shared/Completions" -Filter *.ps1 -Recurse | % { . $_.FullName }
