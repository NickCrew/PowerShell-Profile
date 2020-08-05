# PowerShell Profile
The default user `$profile` is: `Microsoft.PowerShell_profile.ps1`

## Auto-Loading Sequence
1. Source all `*.ps1` files under the __top-level only__ of `Autoload/..`
2. Attempt to import all `$RequiredModules`
3. ???
4. Source all `*.ps1` files under `Autoload/after/..`


## Setup
Optional setup scripts can be found under `Setup/..`.
They are __not__ sourced during normal start-up.

## Dependencies

### PowerShell Modules
Install all recommended modules using the script provided at
````pwsh
Setup\import.ps1
````
Modules to install are defined in `Setup\required_modules.json`
Installs:
- PSFZF
- ZLocation
- cd-extras
- posh-git
- posh-p4
- Get-ChildItemColor


### Executables
Certain functionality requires third-party dependencies to be installed and in your $PATH.

- `fzf.exe` - FZF (Fuzzy Finder)
- `rg.exe` - RipGrep (Ultra-Fast Code Searching)

[Chocolatey is the recommended package manager.]( https://chocolatey.org/packages )

In a `powershell.exe` session with __admin__ privileges:
````pwsh
choco install fzf
choco install ripgrep
````
