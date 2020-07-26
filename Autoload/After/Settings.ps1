<#
.SYNOPSIS
PowerShell Settings

.NOTES
To be sourced at end of $profile
Place in autoload/after/..
#>


if (${Env:OS} -eq 'Windows_NT') {

}
else {

}

## Module: CD-Extras
if ($null -ne (Get-Module cd-extras)) {
	Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:Home}" 'Source')
}

## Module: PSFZF
Set-PsFzfOption -TabExpansion
if ($null -ne (Get-Module PSFZF -ListAvailable)) {
	Remove-PSReadlineKeyHandler 'Ctrl+r'
	Remove-PSReadlineKeyHandler 'Ctrl+t'
}
