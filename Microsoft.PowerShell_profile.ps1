<#
.SYNOPSIS
PowerShell Profile - Primary
#>

## NOTE: Only the top-level of Autoload/.. is sourced at the beginning of $Profile
## The autoload/after directory is not sourced until the end of this file
$autoload = Join-Path $(split-path $profile) 'autoload'
$after = Join-Path $autoload 'after'

Get-ChildItem $autoload -File -Filter *.ps1 | Foreach-Object {
    . $_.FullName
}

## Import any auxialiary modules
$RequiredModules = @(
	'Get-ChildItemColor',
	'PSFZF',
	'PoSh-P4',
	'cd-extras',
	'zlocation'
	)

$RequiredModules | Foreach-Object {
	Import-Module $_ -ErrorAction Continue
}


## Load after/..
Get-ChildItem $after -File -Filter *.ps1 | ForEach-Object {
	. $_.FullName
}
