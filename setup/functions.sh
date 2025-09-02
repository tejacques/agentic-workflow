#!/bin/bash

# Agentic Project Workflow Shared Functions
# Used by install.sh

# Function to copy files from source to destination
copy_file() {
    local source="$1"
    local dest="$2"
    local overwrite="$3"
    local desc="$4"

    if [ -f "$dest" ] && [ "$overwrite" = false ]; then
        echo "  ⚠️  $desc already exists - skipping"
        return 0
    else
        if [ -f "$source" ]; then
            cp "$source" "$dest"
            if [ -f "$dest" ] && [ "$overwrite" = true ]; then
                echo "  ✓ $desc (overwritten)"
            else
                echo "  ✓ $desc"
            fi
            return 0
        else
            return 1
        fi
    fi
}

# Function to copy directory recursively
copy_directory() {
    local source="$1"
    local dest="$2"
    local overwrite="$3"

    if [ ! -d "$source" ]; then
        return 1
    fi

    mkdir -p "$dest"

    # Copy all files and subdirectories
    find "$source" -type f | while read -r file; do
        relative_path="${file#$source/}"
        dest_file="$dest/$relative_path"
        dest_dir=$(dirname "$dest_file")
        mkdir -p "$dest_dir"

        if [ -f "$dest_file" ] && [ "$overwrite" = false ]; then
            echo "  ⚠️  $relative_path already exists - skipping"
        else
            cp "$file" "$dest_file"
            if [ "$overwrite" = true ] && [ -f "$dest_file" ]; then
                echo "  ✓ $relative_path (overwritten)"
            else
                echo "  ✓ $relative_path"
            fi
        fi
    done
}

# Function to convert command file to Cursor .mdc format
convert_to_cursor_rule() {
    local source="$1"
    local dest="$2"

    if [ -f "$dest" ]; then
        echo "  ⚠️  $(basename $dest) already exists - skipping"
    else
        # Create the front-matter and append original content
        cat > "$dest" << EOF
---
alwaysApply: false
---

EOF
        cat "$source" >> "$dest"
        echo "  ✓ $(basename $dest)"
    fi
}