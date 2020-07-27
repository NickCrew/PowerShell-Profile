<#
.SYNOPSIS
PowerShell Settings

.NOTES
Location: autoload/after/..

Sourced after all additional modules are imported

#>


if (${Env:OS} -eq 'Windows_NT') {
	# Place Windows-only settings here
}
else {
	# Place *nix settings here
}

if ($null -ne (Get-Module cd-extras)) {
	Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:Home}" 'Source') -ErrorAction SilentlyContinue
}

if ($null -ne (Get-Module PSFZF)) {
	Set-PsFzfOption -TabExpansion
}
