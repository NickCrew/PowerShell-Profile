Set-PSReadlineOption -Editmode vi
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

