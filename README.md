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
Certain functionality requires third-party dependencies to be installed and in your $PATH.

- `fzf.exe` - FZF (Fuzzy Finder)
- `rg.exe` - RipGrep (Ultra-Fast Code Searching)
