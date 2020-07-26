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
if ($null -ne (Get-Module -ListAvailable -Name cd-extras)) {
    Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:Home}" 'Source')
}

## Module: PSFZF
if ($null -ne (Get-Module -ListAvailable -Name PSFZF)) {
	Remove-PSReadlineKeyHandler 'Ctrl+r'
	Remove-PSReadlineKeyHandler 'Ctrl+t'
}
