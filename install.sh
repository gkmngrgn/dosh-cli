#!/bin/sh
set -e

get_latest_tag() {
    curl -s https://api.github.com/repos/gkmngrgn/dosh-cli/tags \
        | grep 'name.*v[0-9]' \
        | head -n 1 \
        | cut -d '"' -f 4 \
        | sed 's/^v//'
}

main() {
    tag=$(get_latest_tag)
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    architecture=$(uname -m)
    folder_name="dosh-cli-$os-$architecture-$tag"
    download_url="https://github.com/gkmngrgn/dosh-cli/releases/download/v$tag/$folder_name.zip"
    temp_dir=$(mktemp -d)
    app_dir="$HOME/.local/share/dosh-cli"
    bin_file="$HOME/.local/bin/dosh"

    echo "Operating System: $os"
    echo "Architecture: $architecture"
    echo "DOSH CLI version: $tag"
    echo "Temporary directory: $temp_dir"
    echo "Download URL: $download_url"

    printf "\nSTEP 1: Downloading DOSH CLI...\n"
    curl -L "$download_url" -o "$temp_dir/dosh-cli.zip"

    printf "\nSTEP 2: Installing DOSH CLI...\n"
    if [ -d "$app_dir" ]; then
        mv "$app_dir" "$temp_dir/dosh-cli.old"
    fi

    if [ -f "$bin_file" ]; then
        mv "$bin_file" "$temp_dir/dosh.old"
    fi

    unzip "$temp_dir/dosh-cli.zip" -d "$temp_dir"
    mv "$temp_dir/$folder_name" "$app_dir"

    printf '#!/bin/sh\neval "~/.local/share/dosh-cli/dosh $@"\n' > "$bin_file"
    chmod +x "$bin_file"

    printf "\nSTEP 3: Done! You can delete the temporary directory if you want.\n"
}

main
