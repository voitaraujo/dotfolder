
#!/bin/bash

dotfolder="$HOME/dotfolder"

# Check if dotfolder exists
if [ ! -d "$dotfolder" ]; then
    echo "dotfolder doesn't exist in $HOME."
    exit 1
fi

# Function to calculate relative path
get_relative_path() {
    local source="$1"
    local target="$2"
    local common_part="$source"
    local result=""

    while [[ "${target#$common_part}" == "${target}" ]]; do
        common_part="$(dirname "$common_part")"
        result="../${result}"
    done

    result="${result}${target#$common_part/}"

    # Strip "tolink/" prefix if present
    result="${result#tolink/}"

    echo "$result"
}

# Function to ensure directory existence
ensure_directory_exists() {
    local directory="$1"
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
    fi
}

# Loop through files and folders inside dotfolder, including hidden ones
for item in "$dotfolder"/tolink/{.,}*; do
    if [ "$(basename "$item")" != "." ] && [ "$(basename "$item")" != ".." ]; then
        # Check if item is a directory
        if [ -d "$item" ]; then
            # Loop through files and folders inside subdirectory
            for subitem in "$item"/*; do
                # Create symlink with relative path in home directory
                relative_path=$(get_relative_path "$dotfolder" "$subitem")
                target="$HOME/$relative_path"
                ensure_directory_exists "$(dirname "$target")"
                ln -sf "$subitem" "$target"
                echo "Symlinked $(basename "$subitem") to $target"
            done
        # Create symlink for files directly inside dotfolder
        elif [ -f "$item" ]; then
            # Create symlink with relative path in home directory
            relative_path=$(get_relative_path "$dotfolder" "$item")
            target="$HOME/$relative_path"
            ensure_directory_exists "$(dirname "$target")"
            ln -sf "$item" "$target"
            echo "Symlinked $(basename "$item") to $target"
        fi
    fi
done

echo "Symlinking complete."

