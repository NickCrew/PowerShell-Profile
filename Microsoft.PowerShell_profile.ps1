# ####################################################
#
# Name: Microsoft.PowerShell_profile.ps1
# Profile: CurrentUserCurrentHost 
# PSVersion: 7
#
# Profile Load Order: 
#     - AllUsersAllHosts
#     - AllUsersCurrentHost 
#     - CurrentUserAllHosts 
#     - CurrentUserCurrentHost
#
# #####################################################



# use pwsh7 by default in remote sessions
$PSSessionConfigurationName = 'PowerShell.7'

$env:VMWARE_HOME = (Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation')
$env:Editor = 'gvim'
$env:GIT_SSH = 'C:\Windows\System32\OpenSSH\ssh.exe'  # so ssh-agent works correctly and handles passphrases


Set-PSReadlineOption -PredictionSource History
Set-PSReadlineOption -PredictionViewStyle ListView

Import-Module PoSh-Git
Import-Module oh-my-posh 
Set-PoshPrompt pure-custom

Set-Alias -Name iconda -Value Initialize-Anaconda -Force
function Initialize-Anaconda {
	# !! Contents within this block are managed by 'conda init' !!
	(& "${HOME}\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
}

TabExpansion2.ps1
