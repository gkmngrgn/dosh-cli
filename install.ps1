function InstallWithShScript {
    $argList = '-c "curl https://raw.githubusercontent.com/gkmngrgn/dosh-cli/main/install.sh | sh"'
    Start-Process -FilePath "bash" -ArgumentList $argList -Wait
}

function GetLatestTag {
    $url = "https://api.github.com/repos/gkmngrgn/dosh-cli/releases/latest"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $json = $response.Content | ConvertFrom-Json
    return $json.tag_name -replace "^v", ""
}

function GetTempDir {
    $temp_dir = [System.IO.Path]::GetTempPath()
    $temp_dir = [System.IO.Path]::Combine($temp_dir, "dosh-cli")
    $temp_dir = [System.IO.Path]::Combine($temp_dir, [System.IO.Path]::GetRandomFileName())

    if (Test-Path $temp_dir) {
        Remove-Item -Path $temp_dir -Recurse -Force
    }

    New-Item -ItemType Directory -Path $temp_dir | Out-Null

    return $temp_dir
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

    $os = "windows"
    $architecture = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture

    if ($architecture -ne "X64") {
        Write-Error "This script only supports x64 for now."
        return
    } else {
        $architecture = "amd64"
    }

    $tag = GetLatestTag
    $temp_dir = GetTempDir
    $folder_name = "dosh-cli-$os-$architecture-$tag"
    $download_url = "https://github.com/gkmngrgn/dosh-cli/releases/download/v$tag/$folder_name.zip"

    Write-Output "DOSH CLI version: $tag"
    Write-Output "Temporary directory: $temp_dir"
    Write-Output "Download URL: $download_url"

    Write-Output ""

    Write-Output "STEP 1: Downloading DOSH CLI..."
    $zip_file = [System.IO.Path]::Combine($temp_dir, "$folder_name.zip")
    Invoke-WebRequest -Uri $download_url -OutFile $zip_file

    Write-Output "STEP 2: Installing DOSH CLI..."
    Expand-Archive -Path $zip_file -DestinationPath $temp_dir
    # TODO: Check if the directory exists
    # move old files/folders to the temp dir.
    # then expand archive to the app data dir.

    Write-Output "STEP 3: Done! You can delete the temporary directory if you want."
}

Main
