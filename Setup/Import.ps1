<#
.SYNOPSIS
Attempts to import any modules from the array
#>

[CmdletBinding()]
param (
    # Required Modules
    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $RequiredModules = 'required_modules.json',

    # Preferred PS Repository
    [Parameter(Position = 1, Mandatory = $false)]
    [string]
    $PSRepo = 'PSGallery',

    # If a module is not found, attempt to install it
    [Parameter]
    [switch]
    $InstallMissing = $false
)
$ErrorActionPreference = 'Stop'

if ($RequiredModules -eq 'required_modules.json') {
    $src = Join-Path $PSScriptRoot 'required_modules.json'
    $RequiredModules = Get-Content $src | ConvertFrom-Json
}

foreach ($module in $RequiredModules) {
    $gm = Get-Module -Name $module -ListAvailable

    if ($null -ne $gm) {
        try {
            Import-Module $module
        }
        catch {
            Write-Warning $PSItem -WarningAction 'Continue'
        }
    }
    else {
        if ($InstallMissing) {
            try {
                Install-Module $Module -Scope CurrentUser -Repository $PSRepo -AllowClobber -Force
            }
            catch {
                Write-Warning $PSItem -WarningAction 'Continue'
            }
        }
        else {
            Write-Verbose "${module} is not installed but InstallMissing is not enabled."
        }
    }
}
