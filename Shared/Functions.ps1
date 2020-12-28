
function Convert-LineEndings {
	<#
	.SYNOPSIS
		Convert line endings CRLF <==> LF
	.DESCRIPTION
		Default behavior converts CRLF to LF
	.PARAMETER FilePath
		File on which to perform conversion
	.PARAMETER Outfile
		Output converted file contents here.
		Default behavior overwrites original file.
	.PARAMETER ToCRLF
		Convert LF to CRLF
	#>
	[CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript({Test-Path $_})]
        [string]$FilePath,
        [string]$Outfile,
		[switch]$ToCRLF
    )

    if (-not($Outfile)) { $Outfile = $FilePath }

	if ($ToCRLF) {
		$to = '`r`n'
		$from = '`n'
	}
	else {
		$to = '`n'
		$from = '`r`n'
	}

    $new = $contents -replace $from,$to
    $new | Set-Content $Outfile -Encoding ascii -Force
}

Set-Alias -Name to -Value Send-InputTo
function Send-InputTo ($target) {
    # Pipe output to args of $target
    # i.e. gc foo.txt | to gvim
    & ${target} $input 
}

Set-Alias -Name asadmin -Value Invoke-CommandAsAdmin
function Invoke-CommandAsAdmin {
    <#
    .SYNOPSIS
        Converts a command(s) to a scriptblock and executes with 
        elevated privileges
    #>
    param (
        # Commands to execute in scriptblock (in order)
        [Parameter(Position = 0)]
        [string[]]$Command
    )
    if ($IsWindows -or $PSVersionTable.Platform -eq 'Win32NT') {
        if ($Command.Count -gt 1) { $Command = $Command -join ";" }
        $al = "-Command &{ ${Command} }"
        $spi = @{
            FilePath = 'pwsh.exe'
            Verb = 'RunAs'
            ArgumentList = $al
            Wait = $true
            PassThru = $true
        }
        $cmd = Start-Process @spi
        if ($cmd.ExitCode -ne 0) {
            $PSCmdlet.ThrowTerminatingError()
        }
    }
}

 
Set-Alias -Name ocvi -Value Open-ClipboardContentsInGvim
function Open-ClipboardContentsInGvim {
    <#
    .SYNOPSIS
        Open the current clipboard contents in GVim. 'ZZ' saves and exits.
    #>
    & gvim +pu+ "+$d" +1 "+nnoremap &lt;buffer&gt; ZZ :%y+&lt;CR&gt;ZQ" "+set nomod"
}

Set-Alias -Name fp4 -Value Invoke-FuzzyP4Client -Force
function Invoke-FuzzyP4Client {
    <#
    .SYNOPSIS
        Select a Perforce client from list provided by the p4 server using FZF (fuzzy search)
    #>
    [CmdletBinding()]
    param (
        # P4 Clients Root Directory
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $Top = 'C:\p4',

        # P4 Username
        [Parameter(Position = 2, Mandatory = $false)]
        [string]
        $P4User = $env:P4User
    )
    $ErrorActionPreference = 'Stop'

    $clients = New-Object System.Collections.ArrayList

    $clientsRaw = p4 clients -u $P4User
    foreach ($c in $clientsRaw) {
        $name = ($c -split '\s')[1]
        $clients.Add($name) | Out-Null
    }

    $selection = ($clients | fzf)

    $WorkspaceDir = Join-Path $Top $selection

    if (Test-Path $WorkspaceDir) {
        Set-Location $WorkspaceDir
    }
    else {
        New-Item $WorkspaceDir -ItemType Directory -Force
        Set-Location $WorkspaceDir
    }

    p4 set p4client=${selection}
    if ($LASTEXITCODE -ne 0) {
        throw "Error setting p4 client ${selection}"
    }
    else {
        $env:P4Client = $selection
        Write-Verbose "Set P4 Client: ${selection}"
    }

}


Set-Alias -Name fdrepo -Value Find-GitRepos -Force
function Find-GitRepos {
    <#
    .SYNOPSIS
        Find all the folders containing git repos under a given path $Top
    #>
    Param(
        # Directory at which to start the search
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateScript({Test-Path $_})]
        [string]
        $Top = '~/Source',

        [switch]
        $NoTruncatedPaths = $false
    )

    $dirs = @{ }
    $i = 1
    Get-ChildItem $Top -Recurse -File -Filter .git | ForEach-Object {
        $thispath = Split-Path $_.FullName
        if ($NoTruncatedPaths) {
            $displayPath = $thispath
        }
        else {
            $displayPath = ($thisPath -split '\\')[-2..-1] -join '\'
        }
        $dirs.Add($i, $thispath)
        Write-Host "$i : $displayPath"
        $i++
    }
    [int]$selection = Read-Host "Go To"

    $p = ($dirs.GetEnumerator() | Where-Object {
            $_.Key -eq $selection
        } | Select-Object -ExpandProperty Value)

    if (Test-Path $p)
    {
        Set-Location $p
    }
}

function Copy-SshId {
    <#
    .SYNOPSIS
        Copy an SSH public key to a Windows host
    #>
    [CmdletBinding()]
    param (
        # Destination Username 
        [Parameter(Position = 0, Mandatory=$true)]
        [string]
        $User,

        # Destination Hostname or IP
        [Parameter(Position = 1, Mandatory=$true)]
        [string]
        $Hostname,

        # Public key (source) to copy 
        [Parameter(Position = 2, Mandatory=$false)]
        [string]
        $PubKeyPath = '~/.ssh/id_rsa'

    )

    try {
        if (Test-Path $PubKeyPath) {
            $spParams = @{
                FilePath = 'plink.exe'
                ArgumentList = "${User}@${Hostname} umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys"
            }
            Get-Content $PubKeyPath | Start-Process @spParams
        }
    }
    catch {
        throw $PSItem
    }
}

function Start-ShellTranscript {
    <#
    .SYNOPSIS
        Start a new transcript in the specified directory for the current shell
    #>
    [CmdletBinding()]
    param (
        # Log Output Directory
        [Parameter(Position = 0, Mandatory = $false)]
        [string]
        $LogDir = (Join-Path (Split-Path $profile) 'Transcripts')
    )

    if (-not(Test-Path $LogDir)) { New-Item $LogDir -ItemType Directory }
    $Timestamp = $(get-date -Format "yyyyMMddhhmmss")
    $OutFilePath = Join-Path $LogDir "${Timestamp}.log"
    Write-Verbose "Starting transcript at: ${OutFilePath}"

    Start-Transcript $OutFilePath

    $PSCmdlet.MyInvocation.MyCommand
}


Set-Alias -Name fdproc -Value Find-Process -Force
function Find-Process {
    <#
    .SYNOPSIS
        Use pattern matching to find a process by name
    #>
	param (
		[Parameter(Position = 0, Mandatory)]
		[string]
		$Pattern
	)

	$result = Get-Process | Where-Object {
        $_.Name -match $Pattern
    }

    return $result
}


function rgf ($arg) {
    <#
    .SYNOPSIS
        Use Ripgrep to search for filenames
    #>
	rg --files | rg $arg
}

Set-Alias -Name obliterate -Value Remove-ItemRecursiveForced -Force
function Remove-ItemRecursiveForced ($arg) {
    <#
    .SYNOPSIS
        Recursively and forcefully removing all sub-directories and files under $arg
    #>
	$p = @{
		Path    = $arg
		Force   = $true
		Recurse = $true
		Confirm = $true
	}
	Remove-Item @p
}


Set-Alias -Name frg -Value Invoke-FuzzyRgEdit -Force
function Invoke-FuzzyRgEdit {
<#
.SYNOPSIS
    Pipes results of rg into fzf and opens the selection in $EDITOR
#>
    [CmdletBinding()]
    param (
        # Pattern
        [Parameter(Position = 0, Mandatory)]
        [string]
        $Pattern,

        # Editor
        [Parameter()]
        [string]
        $Editor = (& { if ($Env:Editor) { $Env:Editor } else { 'gvim' } }),

        # Search file names
        [Parameter()]
        [switch]
        $Files = $false
    )

    if ($Files) { & ${Editor} $(rgf $Pattern | fzf) }
    else { & ${Editor} $((rg $Pattern | fzf).Split(":")[0]) }
}

# Other Aliases
Set-Alias -Name sclip -Value Set-Clipboard -Force
