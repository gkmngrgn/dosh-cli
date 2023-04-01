function Get-Architecture {
    $processArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
    $architecture = if ($processArchitecture -eq "X64") {
        "x86_64"
    } elseif ($processArchitecture -eq "Arm64") {
        "aarch64"
    } else {
        "unknown"
    }
    return $architecture
}

function Get-OperatingSystem {
    $os = if ($IsWindows) {
        "windows"
    } elseif ($IsMacOS) {
        "darwin"
    } elseif ($IsLinux) {
        "linux"
    } else {
        "unknown"
    }
    return $os
}

function Main {
    $os = Get-OperatingSystem
    $architecture = Get-Architecture

    Write-Output "Operating System: $os"
    Write-Output "Architecture: $architecture"
    Write-Output "DOSH CLI version: $tag"
    Write-Output "Temporary directory: $temp_dir"
    Write-Output "Download URL: $download_url"

    Write-Output "`r`nSTEP 1: Downloading DOSH CLI..."
    Write-Output "`r`nSTEP 2: Installing DOSH CLI..."
    Write-Output "`r`nSTEP 3: Done! You can delete the temporary directory if you want."
}

Main
