[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $force
)

# [CmdletBinding()]
# param (
#     [Parameter()]
#     [string]
#     $package = "",
#     [Parameter()]
#     [int]
#     $versionBump = 0,
#     [Parameter()]
#     [switch]
#     $override,
#     [Parameter()]
#     [switch]
#     $add
# )

# if (-not $add) {

#     if (-not $package) {
#         $package = Read-Host "Enter the package name`n"
#     }

#     if (-not (Test-Path -Path ".\_templates\$package")) {
#         Write-Error "Package $package not found"
#         exit 1
#     }

#     $tomlPath = ".\_templates\$package\typst.toml"
#     $toml = Get-Content -Path $tomlPath -Raw

#     $currentVersion = $toml | Select-String -Pattern 'version = "(\d+\.\d+\.\d+)"' | ForEach-Object { $_.Matches.Groups[1].Value }
#     if (-not $currentVersion) {
#         Write-Error "Version not found in $package\typst.toml"
#         exit 1
#     }

#     $targetVersion = $currentVersion

#     if (-not $override) {
#         if (-not $versionBump) {
#             $versionBump = Read-Host "Enter the version bump (3 = patch + 1, 2 = minor + 1, 1 = major + 1)`n(default: 3)"
#             if (-not $versionBump -or $versionBump -notmatch '^[1-3]$') {
#                 $versionBump = 3
#             }
#         }

#         $versionParts = [string[]]$currentVersion.Split('.')
#         $versionParts[$versionBump - 1] = [int]$versionParts[$versionBump - 1] + 1

#         for ($i = $versionBump; $i -lt $versionParts.Length; $i++) {
#             $versionParts[$i] = '0'
#         }

#         $targetVersion = $versionParts -join '.'
    
#         $toml = $toml -replace 'version = "(\d+\.\d+\.\d+)"', "version = `"$targetVersion`""
#         Set-Content -Path $tomlPath -Value $toml
#         Write-Host "Version bumped to $targetVersion for $package"
#     }
#     else {
#         Write-Host "Override flag detected. Using current version $targetVersion for $package"
#     }

#     $destPath = "$env:LOCALAPPDATA\typst\packages\local\$package\$targetVersion"
#     robocopy .\_templates\$package $destPath /MIR /NFL /NDL /NJH /NJS /nc /ns

# }
# else {
#     $packages = Get-ChildItem -Path ".\_templates" -Directory | ForEach-Object { 
#         if (Test-Path -Path ".\_templates\$($_.Name)\typst.toml") {
#             $toml = Get-Content -Path ".\_templates\$($_.Name)\typst.toml" -Raw
#             $version = $toml | Select-String -Pattern 'version = "(\d+\.\d+\.\d+)"' | ForEach-Object { $_.Matches.Groups[1].Value }
#             return [PSCustomObject]@{
#                 Name    = $_.Name
#                 Version = $version
#                 Path    = ".\_templates\$($_.Name)\typst.toml"
#             }
#         }
#     } | Sort-Object -Property Name
#     $packages | Format-Table -Property Name, Version, Path
#     $addPackages = Read-Host "Enter the packages to add (comma separated)`n(default: all)"
#     if ($addPackages) {
#         $addPackages = $addPackages.Split(',')
#     }
#     else {
#         $addPackages = $packages | ForEach-Object { $_.Name }
#     }
#     foreach ($package in $addPackages) {
#         try {
#             $version = $packages | Where-Object { $_.Name -eq $package } | ForEach-Object { $_.Version }
#             robocopy .\_templates\$package $env:LOCALAPPDATA\typst\packages\local\$package\$version /MIR /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
#             Write-Host "Added $($package):$($version) to local packages" -ForegroundColor Green
#         }
#         catch {
#             Write-Error "Failed to add $($package):$($version) to local packages"
#             exit 1
#         }
#     }
#     exit 0
# }

$packagesPath = "$env:LOCALAPPDATA\typst\packages"
$localPackagesPath = "$packagesPath\local"
$repoPackagesPath = "$($pwd.path)"

function Add-LocalPackages {
    Remove-Item -Path $localPackagesPath -Recurse -Force
    New-Item -ItemType Junction -Path $packagesPath -Name local -Value $repoPackagesPath -Force
}
if (-not (Test-Path -Path $localPackagesPath) -and -not $force) {
    Add-LocalPackages
    Write-Host "Local packages set up" -ForegroundColor Green
    exit 0
}
elseif ((Get-Item $localPackagesPath).LinkType -eq "SymbolicLink" -and -not $force) {
    Write-Host "Local packages already set up" -ForegroundColor Green
    exit 0
}
elseif ((Test-Path -Path $localPackagesPath) -and -not (Get-Item $localPackagesPath).LinkType -or $force) {
    Write-Host "The local packages path is a directory" -ForegroundColor Yellow
    # Move-Item -Path $localPackagesPath -Destination "$localPackagesPath.bak"
    Add-LocalPackages
    Write-Host "Local packages set up" -ForegroundColor Green
    exit 0
}
