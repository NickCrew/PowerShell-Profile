<#
.SYNOPSIS
PSReadLine Settings and other input behavior
#>

## Vi Mode
Set-PSReadlineOption -EditMode vi -BellStyle None
Set-PSReadlineOption -BellStyle None

## Search History
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward

## Completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
