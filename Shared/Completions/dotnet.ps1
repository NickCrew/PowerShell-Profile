# Dotnet completions

if ($null -ne (Get-Command dotnet)) {
   Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
      param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
               [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
   }
}
