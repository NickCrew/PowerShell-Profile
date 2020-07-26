<#
.SYNOPSIS
PowerShell Functions
#>

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
        $Top = 'C:\p4'
    )
    $ErrorActionPreference = 'Stop'

    Set-Location $((Get-ChildItem $Top -Directory).FullName | fzf)

    $name = Get-Location | Get-Item | Select-Object -ExpandProperty BaseName

    p4 set p4client=${name}
    if ($LASTEXITCODE -ne 0) {
        throw "Error setting p4 client ${name}"
    }
    else {
        Write-Verbose "Set P4 Client: ${name}"
    }

}

function Invoke-FuzzyCodeWorkspace {
    [CmdletBinding()]
    param (
        # Top of search tree
        [Parameter(Position = 0, Mandatory = $false)]
        [string]
        $Top = '~/Source/VSCode_Workspaces',

        # VSCode Flavor
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $Flavor = 'code-insiders'
    )
    $ErrorActionPreference = 'Stop'

    $selection = $((Get-ChildItem $Top -File -Filter *.code-workspace).BaseName | fzf)
    $fullpath = Get-ChildItem $Top -File -Filter *.code-workspace |
                Where BaseName -eq $Selection |
                Select-Object -ExpandProperty FullName

    &${Flavor} $fullpath
}

function Set-P4Client {
    <#
    .SYNOPSIS
    List and select Perforce client directories
    #>
    Param(
        # Search Pattern
        [Parameter(Position = 0, Mandatory = $false)]
        [string]
        $Pattern,

        # P4 Clients Root Directory
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $Top = 'C:\p4'
    )
    $ErrorActionPreference = 'Stop'

    $dirs = [System.Collections.ArrayList] @()

    if (-not [String]::IsNullOrEmpty($Pattern)) {
        $Found = Get-ChildItem $Top -Directory | Where BaseName -match $Pattern

        if ($Found.Count -gt 1) {
            $counter = 1
            foreach ($f in $Found) {
                $obj = [pscustomobject] @{
                    Id = $counter
                    Name = $f.BaseName
                    Path = $f.FullName
                }
                $dirs.Add($obj) | Out-Null
                $counter++
            }
        }
        else {
            $clientName = $Found.BaseName
            Set-Location $Found.FullName

            p4 set p4client=$clientName
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to set p4 client to ${clientName}"
            }

            return $true
        }
    }
    else {
        $counter = 1
        Get-ChildItem $Top -Directory  | ForEach-Object {
            $obj = [pscustomobject] @{
                Id = $counter
                Name = $_.BaseName
                Path = $_.FullName
            }
            $dirs.Add($obj) | out-null
            $counter++
        }
    }

    $dirs | Select-Object -Property Id, Name | Format-Table

    [int]$selection = Read-Host "Select Workspace"

    $x = $dirs | Where-Object {
        $_.Id -eq $selection
    }
    $selPath = $x.Path
    $clientName = Split-Path $x.Path -leaf

    Set-Location $selpath
    p4 set p4client=$clientName
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to set p4 client to ${clientName}"
    }

    return $true
}

function Search-CalibreDb {
	<#
	.SYNOPSIS
	Search the calibre database with a term

	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string]
		$SearchTerm
	)

	$query = Invoke-Expression "calibredb search '${SearchTerm}'"
	$found = $query -split ','
	$results = [System.Collections.ArrayList]@()
	foreach ($id in $found) {
		[regex]$rx = "^\d+(?=\s+)"
		$db = Invoke-Expression "calibredb list"
		$query = $db | Where-Object {
			$rx.Match($_).Value -eq $Id
		}

		$results.Add($query) | Out-Null
	}
	return $results
}

function Open-VSCodeWorkspace {
    <#
    .SYNOPSIS
    List and Open VSCode workspaces

    #>
    Param(
        # VSCode Workspaces DIr
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateScript({Test-Path $_})]
        [string]
        $Top = '~/Source/VSCode_Workspaces'
    )
    $ErrorActionPreference = 'Stop'


    $dirs = @{}
    $i = 1
    Get-ChildItem $Top -Recurse -File -Filter *.code-workspace | ForEach-Object {
        $fullPath = $_.FullName
        $displayPath = $_.BaseName

        $dirs.Add($i, $fullPath)
        Write-Host "$i : $displayPath"
        $i++
    }
    [int]$selection = Read-Host "Open Workspace"

    $p = ($dirs.GetEnumerator() | Where-Object {
            $_.Key -eq $selection
        } | Select-Object -ExpandProperty Value)

    if (Test-Path $p)
    {
        cmd.exe /c code-insiders $p
    }
}

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
}

function Invoke-ChocoInstall ($arg) {
    Start-Process powershell -Verb Runas -ArgumentList "choco install $arg"
}

function Open-VSCodeInsiders ($arg) {
    Invoke-Expression "code-insiders $arg"
}

function Find-Proc {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[string]
		$Name,

		[switch]
		$Sigterm = $false
	)

	$result = Get-Process | Where Name -match $arg

	if ($Sigterm) {
		Stop-Process -Id $result.Id -Verbose
	}
	else {
		return $result
	}
}

function Open-DevP4 {
    <#
    .SYNOPSIS
    Launch devLaunchVS.bat for the current p4 workspace (if exists)
    #>

    param (
        # Depth to search
        [Parameter(Position=0,Mandatory=$false)]
        [int32]
        $SearchDepth = 2
    )

    $clientSpec = p4 client -o
    if ($LASTEXITCODE -ne 0) {
        throw "Failed getting client specification."
    }

    $p4Dir = (($clientSpec | Select-String "^Root") -split '\s+')[1]

    if (Test-Path $p4Dir) {
        $collect = New-Object System.Collections.ArrayList
        $counter = 0
        Get-ChildItem $p4dir -File -Depth $SearchDepth -Filter DevLaunchVS.bat | ForEach-Object {
            $p = Split-Path $_.FullName -Parent
            $obj = [PScustomObject] @{
                Id = $counter
                Project = $p
                Fullpath = $_.FullName
            }
            $collect.Add($obj) | Out-Null
            $counter++
        }
        $collect | Select-Object -Property Id, Project | Format-Table

        [int]$selection = Read-Host "Select Workspace"

        $x = $dirs | Where-Object {
            $_.Id -eq $selection
        }

        $path = $x.FullPath

        & cmd.exe /c $path
    }
    else {
        throw "${p4Dir} does not exist"
    }
}

function rgf ($arg) {
    <#
    .SYNOPSIS
    Use Ripgrep to search for filenames
    #>
	rg --files | rg $arg
}

function rmrf ($arg) {
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

function Initialize-Anaconda {
    $condaExe = Join-Path ${env:Home} 'anaconda3\Scripts\conda.exe'
    if (Test-Path $condaExe) {
        (& "${condaExe}" "shell.powershell" "hook") | Out-String | Invoke-Expression
    }
}

function Import-GoUtils {
    $top = Join-Path (Get-location).drive.root 'p4'

    $p4Dir = Get-ChildItem $top -Directory | Where-Object {
        $_.BaseName -match 'DevOps' -or
        $_.BaseName -match 'GoUtils'
    } | Select-Object -First 1 -ExpandProperty FullName

    $goUtilsModulePath = Get-ChildItem $p4Dir -Depth 2 -File -Filter *.psd1 | Where-Object {
        $_.BaseName -match 'goUtils'
    } | Select-Object -ExpandProperty FullName

    Import-Module $goUtilsModulePath
}


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
