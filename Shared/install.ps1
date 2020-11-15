
$RequiredModules = @(
    @{ Name = 'PSFZF'; },
    @{ Name = 'ZLocation' },
    @{ Name = 'cd-extras' },
    @{ Name = 'posh-git' },
    @{ Name = 'posh-p4' },
    @{ Name = 'Get-ChildItemColor' },
    @{ Name = 'oh-my-posh'; RequiredVersion = '2.0.487' }
)

foreach ($module in $RequiredModules) {
    Install-Module @module -Repository PSGallery -Scope CurrentUser -Force
}
