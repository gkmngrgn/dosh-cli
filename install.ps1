function InstallWithShScript {
    $argList = '-c "curl https://raw.githubusercontent.com/gkmngrgn/dosh-cli/main/install.sh | sh"'
    Start-Process -FilePath "bash" -ArgumentList $argList -Wait
}

function Main {
    if (!$IsWindows) {
        Write-Output ""
        Write-Output "This script supports only Windows. Fetching `install.sh` from GitHub..."
        Write-Output "If you want to install DOSH CLI on Linux, macOS or other operating systems, please use the `install.sh` script."
        Write-Output ""

        InstallWithShScript
        return
    }

    $architecture = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture

    if ($architecture -ne "X64") {
        Write-Error "This script only supports x64 for now."
        return
    }

    Write-Output "DOSH CLI version: $tag"
    Write-Output "Temporary directory: $temp_dir"
    Write-Output "Download URL: $download_url"

    Write-Output "`r`nSTEP 1: Downloading DOSH CLI..."
    Write-Output "`r`nSTEP 2: Installing DOSH CLI..."
    Write-Output "`r`nSTEP 3: Done! You can delete the temporary directory if you want."
}

Main
