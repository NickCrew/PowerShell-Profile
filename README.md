# PowerShell User Profile

Includes (by load order):
1. CurrentUserAllHosts (`profile.ps1`)
2. CurrentUserCurrentHost (`Microsoft.PowerShell_profile.ps1`)


## Module and Script Dependencies

These are the modules or scripts required for full functionality of profile components.
I like running the betas for _PSReadline_ and _oh-my-posh_ because there's a lot of cool stuff being added all the time.

````powershell
Install-Module Posh-git,PSFZF,zlocation,Get-ChildItemColor -Scope CurrentUser
Install-Module PSReadline,oh-my-posh -AllowPrerelease -Scope Current
Install-Script TabExpansion2 -Scope CurrentUser
````

## External Dependencies

- `fzf` (fuzzy finder)
- `rg` (ripgrep)

Both `fzf` and `rg` are under `bin/` with aliases set in the profiles but if you want to install them anyway:  

````pwsh
choco install fzf
````

````pwsh
choco install ripgrep
````
