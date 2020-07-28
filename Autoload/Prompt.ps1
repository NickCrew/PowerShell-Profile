<#
.SYNOPSIS
PowerShell Prompt Configuration

.NOTES
Requires the PoSh-Git module
#>


# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # # Reset color, which can be messed up by Enable-GitColors
    #$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    # Write-Host($pwd.ProviderPath) -nonewline
    Write-Host($pwd.ProviderPath)

    Write-VcsStatus

    $Host.UI.RawUI.WindowTitle = "..\$(Split-path (Split-Path (get-location).path -parent) -leaf)\$(split-path (get-location) -leaf)"
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}
#endregion

#region Script
Import-Module PoSh-Git -ErrorAction 'Stop'

# Override some Git colors

$s = $global:GitPromptSettings

$s.EnableFileStatus = $true

$s.LocalDefaultStatusForegroundColor    = $s.LocalDefaultStatusForegroundBrightColor
$s.LocalWorkingStatusForegroundColor    = $s.LocalWorkingStatusForegroundBrightColor

$s.BeforeIndexForegroundColor           = $s.BeforeIndexForegroundBrightColor
$s.IndexForegroundColor                 = $s.IndexForegroundBrightColor

$s.WorkingForegroundColor               = $s.WorkingForegroundBrightColor

Pop-Location
