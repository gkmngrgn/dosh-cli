#!/bin/bash
set -e

main() {
    tag=$1
    folder_name="dosh-cli-windows-amd64-$tag"
    download_url="https://github.com/gkmngrgn/dosh-cli/releases/download/v$tag/$folder_name.zip"

    printf "\nSTEP 1: Downloading DOSH CLI...\n"
    curl -OL "$download_url"

    printf "\nSTEP 2: Preparing installer with Inno Setup...\n"
    if [ -d "$folder_name" ]; then
        rm -rf "$folder_name"
    fi
    unzip "$folder_name.zip"
    docker run --rm -i -v "$PWD:/work" amake/innosetup dosh-cli.iss

    printf "\nSTEP 3: Archiving output...\n"
    cd Output
    zip -r "$folder_name-installer.zip" "$folder_name-installer.exe"
}

if [ -z "$1" ]; then
    echo "Usage: $0 <tag>"
    exit 1
fi

main "$1"
