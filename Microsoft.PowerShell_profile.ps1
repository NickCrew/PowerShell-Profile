# PowerShell 7 Profile
#

$myPrompt = 'git'
$myPsFiles = "${PSScriptRoot}/shared"

$env:VMWARE_HOME = (Join-Path "${env:ProgramFiles(x86)}" 'VMWare/VMWare Workstation')
$env:Editor = 'gvim'
$env:GIT_SSH = 'C:\Windows\System32\OpenSSH\ssh.exe'  # so ssh-agent works correctly and handles passphrases

Set-PSReadlineOption -EditMode vi -BellStyle None
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+s -Function SwapCharacters
Set-PSReadlineKeyHandler -Key Alt+r -Function ViSearchHistoryBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

. "${myPsFiles}/Prompts/${myPrompt}.prompt.ps1"
gci "${myPsFiles}/Autoload" -exclude after -Filter *.ps1 -Recurse | % { . $_.FullName }
gci "${myPsFiles}/Autoload/After"  -Filter *.ps1 -Recurse | % { . $_.FullName }
