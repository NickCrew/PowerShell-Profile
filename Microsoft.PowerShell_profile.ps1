# Name: Microsoft.PowerShell_profile.ps1
# Profile: CurrentUserCurrentHost 
# Loads after: AllUsersAllHosts, AllUsersCurrentHost, CurrentUserAllHosts 
# Loads before:
# PSVersion: 7

$env:VMWARE_HOME = (Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation')
$env:Editor = 'gvim'
$env:GIT_SSH = 'C:\Windows\System32\OpenSSH\ssh.exe'  # so ssh-agent works correctly and handles passphrases

Import-Module PoSh-Git
Import-Module oh-my-posh -RequiredVersion 2.0.487
Set-Theme pure

. "${PSScriptRoot}/Shared/Functions.ps1"

Set-Alias -Name co -Value code-insiders.cmd -Force

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
# Import-Module cd-extras
# $cde.CD_PATH = @(
#     (Join-Path ${HOME} 'Source'),
#     (Join-Path ${HOME} 'OneDrive')
# )
# setocd PathCompletions Invoke-VSCode
# setocd PathCompletions Invoke-GVim
# setocd ColorCompletion $true

# function invokePrompt() { [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt() }
# @{
#   'Alt+^'         = { if (up  -PassThru) { invokePrompt } }
#   'Alt+['         = { if (cd- -PassThru) { invokePrompt } }
#   'Alt+]'         = { if (cd+ -PassThru) { invokePrompt } }
#   'Alt+Backspace' = { if (cdb -PassThru) { invokePrompt } }
# }.GetEnumerator() | % { Set-PSReadLineKeyHandler $_.Name $_.Value }


Set-Alias -Name iconda -Value Initialize-Anaconda -Force
function Initialize-Anaconda {
	# !! Contents within this block are managed by 'conda init' !!
	(& "${HOME}\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
}
