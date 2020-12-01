# sourced by all other profiles
#
TabExpansion2.ps1
Invoke-Build.ArgumentCompleters.ps1

Set-Alias -Name code -Value code-insiders.cmd -Force
Set-Alias -Name code.cmd -Value code-insiders.cmd -Force

Set-Alias -Name iconda -Value Initialize-Anaconda -Force
function Initialize-Anaconda {
	# !! Contents within this block are managed by 'conda init' !!
	(& "${HOME}\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
}

