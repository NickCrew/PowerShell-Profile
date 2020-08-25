# After/Settings

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
Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:UserProfile}" 'Source') -ErrorAction SilentlyContinue
