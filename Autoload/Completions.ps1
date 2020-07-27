<#
.SYNOPSIS
# PowerShell Completions
#>

# dotnet
if ($null -ne (Get-Command dotnet)) {
   Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
      param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
               [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
   }
}

if ($null -ne (Get-Command p4)) {
   Import-Module Posh-P4 -ErrorAction SilentlyContinue
}
