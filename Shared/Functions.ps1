
function to ($target) { &$target $input }

Set-Alias -Name asadmin -Value Invoke-CommandAsAdmin
function Invoke-CommandAsAdmin ( $ArgumentList ) {
	if ($ArgumentList.Count -gt 1) {
		$ArgumentList = $ArgumentList -join " "
	}
	Start-Process pwsh.exe -Verb RunAs -ArgumentList "-Command ${ArgumentList}"
}

#region Functions
Set-Alias -Name fp4 -Value Invoke-FuzzyP4Client -Force
function Invoke-FuzzyP4Client {
<#
.SYNOPSIS
    Select a Perforce client using FZF (fuzzy search)
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
    Locate all the folders containing git repos under a given path

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
    [CmdletBinding()]
    param (
        # Username
        [Parameter(Position = 0, Mandatory=$true)]
        [string]
        $User,

        # Hostname or IP
        [Parameter(Position = 1, Mandatory=$true)]
        [string]
        $Hostname,

        # Path to public key
        [Parameter(Position = 2, Mandatory=$false)]
        [string]
        $PubKeyPath = '~/.ssh/id_rsa'

    )
    $ErrorActionPreference = 'Stop'

    if (Test-Path $PubKeyPath) {
        $spParams = @{
            FilePath = 'plink.exe'
            ArgumentList = "${User}@${Hostname} umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys"
        }
        Get-Content $PubKeyPath | Start-Process @spParams
    }
}

function Start-ShellTranscript {
    [CmdletBinding()]
    param (
        # Log Output Directory
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateScript({Test-Path $_})]
        [string]
        $LogDir
    )

    if ([String]::IsNullOrEmpty($LogDir)) {
        $LogDir = Join-Path (Split-Path $Profile) 'Transcripts'
    }

    if (-not (Test-Path $LogDir)) {
        New-Item $LogDir -ItemType Directory -Force
    }

    $Timestamp = $(get-date -Format "yyyyMMddhhmmss")
    $OutFilePath = Join-Path $LogDir "${Timestamp}.log"
    Write-Verbose "Starting transcript at: ${OutFilePath}"

    Start-Transcript $OutFilePath

    $PSCmdlet.MyInvocation.MyCommand
}


Set-Alias -Name fdproc -Value Find-Process -Force
function Find-Process {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[string]
		$Name
	)

	$result = Get-Process | Where-Object {
        $_.Name -match $arg
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
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $Pattern,

        # Editor
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $Editor = $Env:Editor,

        # Search file names
        [switch]
        $Files = $false
    )

    if ([String]::IsNullOrEmpty($Editor)) {
        $Editor = 'gvim'
    }

    if ($Files) {
        &${Editor} $(rgf $Pattern | fzf)
    }
    else {
        &${Editor} $((rg $Pattern | fzf).Split(":")[0])
    }

}
#endregion

#region Aliases
Set-Alias -Name sclip -Value Set-Clipboard -Force
#endregion
