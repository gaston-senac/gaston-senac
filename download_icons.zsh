#!/usr/bin/env zsh

# Configuration
REPO_OWNER="tandpfun"
REPO_NAME="skill-icons"
ICONS_DIR="icons"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/icons"
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/contents/icons"

# Create icons directory if it doesn't exist
mkdir -p "$ICONS_DIR"

echo "Fetching icon list from GitHub..."

# Fetch the list of filenames using the GitHub API
# We use grep and sed to parse the JSON names simply to avoid dependency on jq
filenames=($(curl -s "$API_URL" | grep '"name":' | sed -E 's/.*"name": "(.*)".*/\1/'))

if [ ${#filenames[@]} -eq 0 ]; then
    echo "Error: Could not fetch filenames. Please check your internet connection or API limits."
    exit 1
fi

echo "Found ${#filenames[@]} icons. Starting download..."

# Download icons in parallel (using a simple loop, but curl is fast)
for file in "${filenames[@]}"; do
    if [[ -f "$ICONS_DIR/$file" ]]; then
        echo "Skipping $file (already exists)"
        continue
    fi
    
    echo "Downloading $file..."
    curl -s -L "$BASE_URL/$file" -o "$ICONS_DIR/$file"
done

echo "Download complete! All icons are saved in the '$ICONS_DIR' folder."
