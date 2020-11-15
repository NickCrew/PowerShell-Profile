
Set-Alias -Name inconda -Value Initialize-Conda -Force
function Initialize-Conda {
    $condaCmd = (Get-Command conda.exe)
    if ($null -ne $condaCmd) {
        $condaExe = $condaCmd.Source
    }
    elseif (Test-Path (Join-Path $HOME 'anaconda3/Scripts/conda.exe')) {
        $condaExe = Join-Path $HOME 'anaconda3\Scripts\conda.exe'
    }
    else {
        throw 'conda.exe not found.'
    }
    (& "${condaExe}" "shell.powershell" "hook") | Out-String | Invoke-Expression
}
