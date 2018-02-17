<#
.SYNOPSIS
    Resolves the version for a RSMassTransit build.

.DESCRIPTION
    This script merges version information from the source code, branch name, and build counter.

    The resulting version is published as follows:
    * In Assembly(|File|Informational)Version attributes in GlobalAssemblyInfo.cs
    * As console output intended to set the TeamCity build number
#>
param (
    # Name of the branch or tag.
    [Parameter(Position=1)]
    [ValidateNotNullOrEmpty()]
    [string] $Branch = "local",

    # Build counter.
    [Parameter(Position=2)]
    [ValidateRange(1, [long]::MaxValue)]
    [long] $Counter = ([DateTime]::Now - [DateTime]::new(2018, 1, 1)).TotalMinutes
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$PullRequestRegex = [regex] '(?nx)
    ^pulls/
    (?<Number> [1-9][0-9]* )
    $
'

# Reference:
# https://github.com/semver/semver/blob/master/semver.md
# + allowance for fourth number
$ReleaseRegex = [regex] '(?nx)
    ^release/
    (?<Version>
        (?<Numbers>
            ( 0 | [1-9][0-9]* )
            (
                \.
                ( 0 | [1-9][0-9]* )
            ){2,3}
        )
        # Pre-release tag
        (
            -
            ( 0 | [1-9][0-9]* | [0-9]*[a-zA-Z-][0-9a-zA-Z-]* )
            (
                \.
                ( 0 | [1-9][0-9]* | [0-9]*[a-zA-Z-][0-9a-zA-Z-]* )
            )*
        )?
        # Build metadata
        (
            \+
            [0-9a-zA-Z-]+
            (
                \.
                [0-9a-zA-Z-]+
            )*
        )?
    )
    $
'

# Get code's version number
. (Join-Path $PSScriptRoot Version.ps1)

if ($Branch -match $ReleaseRegex) {
    # Branch name contains a usable version string (e.g. in a release scenario)
    $BranchVersion     = [version] $Matches.Numbers # 1.2.3
    $BranchVersionFull = [string]  $Matches.Version # 1.2.3-pre+123

    # Verify branch matches code version
    if ($BranchVersion -ne $Version) {
        throw "Branch version ($BranchVersion) does not match code version ($Version)."
    }

    # Use branch version verbatim
    $BuildNumber = $BranchVersionFull
}
elseif ($Branch -match $PullRequestRegex) {
    $BuildNumber = "{0}-pr.{1}.{2}" -f $Version, $Matches.Number, $Counter
}
else {
    $BuildNumber = "{0}-{1}.{2}" -f $Version, $Branch, $Counter
}

# Apply version number to code.
Set-Content GlobalAssemblyInfo.cs -Encoding UTF8 -Value $(
    # Remove existing version attributes
    Select-String `
        '^// Generated|Assembly(File|Informational)?Version' `
        GlobalAssemblyInfo.cs -NotMatch -Encoding utf8 | % Line

    # Append new version attributes
    ""
    "// Generated by Resolve-Version.ps1"
    "[assembly: AssemblyVersion              (`"$Version`")]"
    "[assembly: AssemblyFileVersion          (`"$Version.$Counter`")]"
    "[assembly: AssemblyInformationalVersion (`"$BuildNumber`")]"
)

# Tell TeamCity the new build number
Write-Output "##teamcity[buildNumber '$BuildNumber']"
