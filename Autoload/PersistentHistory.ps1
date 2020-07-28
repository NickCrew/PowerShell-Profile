<#
.SYNOPSIS
Persistent PowerShell history

.NOTES
You must close your shell with 'exit' or the event which
write that session's history will not be triggered

PSReadline history is separate from Get-History

#>
param (
    [string]$HistFileName = 'pshistory.xml'
)

$MaximumHistoryCount = 500
$HistoryFilePath = Join-Path (Split-Path $profile) ${HistFileName}

Register-EngineEvent PowerShell.Exiting -Action {
    Get-History | Export-Clixml $HistoryFilePath
} | Out-Null

if (Test-path $HistoryFilePath) {
	$len = (Get-ChildItem (split-path $Profile) -filter $histfilename).length
	if ($len -gt 0) {
		try {
			Import-Clixml $HistoryFilePath | Where-Object {
				$count++; $true
			} | Add-History
			Write-Host -ForegroundColor "Green" "Loaded ${count} History  Items"
		}
		catch {
			Write-Host -ForegroundColor "Red" "${HistFileName} is corrupt. Deleting..."
			Remove-Item -Path $HistoryFilePath -Force
		}
	} else {
		Write-Host -ForegroundColor "Yellow" "No history loaded. ${HistoryFilepath} does not exist."
	}
}

# Helper functions and aliases
New-Alias -Name ih -Value Invoke-History -Description "Invoke history alias"

Rename-Item Alias:\h original_h -Force

function h {
	Get-History -c  $MaximumHistoryCount
}

function hg ($arg) {
	Get-History -c $MaximumHistoryCount | Out-String -stream | Select-String $arg
}
