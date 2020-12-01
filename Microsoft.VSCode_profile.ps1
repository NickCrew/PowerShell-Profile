 Set-PSReadlineOption -Editmode vi
 Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
 Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

if (Test-Path "$PSScriptRoot/Vispero.VSCode_profile.ps1") { . "$PSScriptRoot/Vispero.VSCode_profile.ps1" }
