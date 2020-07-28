<#
.SYNOPSIS
PowerShell Profile - Primary
#>

## Vars
$env:Editor = 'gvim'

# NOTE: Autoload/after/.. is to be sourced LAST
$autoload = Join-Path $(split-path $profile) 'autoload'
$after = Join-Path $autoload 'after'

## Import modules
$RequiredModules = @(
	'Get-ChildItemColor',
	'PSFZF',
	'PoSh-P4',
	'cd-extras',
	'zlocation'
	)

$RequiredModules | Foreach-Object {
	Import-Module $_ -ErrorAction SilentlyContinue
}

## autoload/..
gci $autoload -Exclude after | gci -File -Recurse -Filter *.ps1  | % {
	. $_.FullName
}

Set-CdExtrasOption -Option CD_PATH -Value (Join-Path "${Env:Home}" 'Source') -ErrorAction SilentlyContinue
Set-PsFzfOption -TabExpansion -ErrorAction SilentlyContinue

## after/..
Get-ChildItem $after -Recurse -File -Filter *.ps1 | ForEach-Object {
	. $_.FullName
}
