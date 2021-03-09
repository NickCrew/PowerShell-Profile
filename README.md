# PowerShell 7 User Profile

## Load Order
1. AllUsersAllHosts
2. AllUsersCurrentHost
3. CurrentUserAllHosts
4. CurrentUserCurrentHost

## Module and Script Dependencies

I like running the betas for PSReadline and oh-my-posh because there's a lot of cool stuff being added all the time.

````powershell
Install-Module Posh-git,PSFZF,Get-ChildItemColor,zlocation -Scope CurrentUser
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
