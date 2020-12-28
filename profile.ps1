######################################################
# Name: profile.ps1
# Profile: CurrentUserAllHosts
# Loads after: AllUsers, AllHosts
# Loads before: CurrentUserCurrentHost
# PSVersion: 7
######################################################

# PSReadline
Set-PSReadlineOption -EditMode vi 
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Completion
TabExpansion2.ps1
Invoke-Build.ArgumentCompleters.ps1
gci "${PSScriptRoot}/Shared/Completions" -Filter *.ps1 -Recurse | % { . $_.FullName }

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Users\ncf42\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

