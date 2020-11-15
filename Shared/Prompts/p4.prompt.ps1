
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    #perforce status
    Write-P4Prompt
    $Host.UI.RawUI.WindowTitle = "..\$(Split-path (Split-Path (get-location).path -parent) -leaf)\$(split-path (get-location) -leaf)"
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Import-Module posh-p4 -Force
