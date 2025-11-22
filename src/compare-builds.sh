#!/bin/bash
# Binary Comparison Script
# Compares local build with official release

compare_files() {
    local file1=$1
    local file2=$2
    
    if [ ! -f "$file1" ]; then
        echo "Error: Local build not found: $file1"
        return 1
    fi
    
    if [ ! -f "$file2" ]; then
        echo "Error: Official release not found: $file2"
        return 1
    fi
    
    echo "Comparing files..."
    echo "Local:    $file1"
    echo "Official: $file2"
    echo ""
    
    # Get file sizes
    local size1=$(stat -f%z "$file1" 2>/dev/null || stat -c%s "$file1" 2>/dev/null)
    local size2=$(stat -f%z "$file2" 2>/dev/null || stat -c%s "$file2" 2>/dev/null)
    
    echo "Size comparison:"
    echo "Local:    $size1 bytes"
    echo "Official: $size2 bytes"
    
    if [ "$size1" != "$size2" ]; then
        echo " MISMATCH: File sizes differ"
        return 1
    fi
    
    echo "✓ Sizes match"
    echo ""
    
    # Calculate SHA256 hashes
    echo "Calculating SHA256 hashes..."
    local hash1=$(sha256sum "$file1" | cut -d' ' -f1)
    local hash2=$(sha256sum "$file2" | cut -d' ' -f1)
    
    echo "Local:    $hash1"
    echo "Official: $hash2"
    echo ""
    
    if [ "$hash1" = "$hash2" ]; then
        echo "SUCCESS: Hashes match - Build is reproducible!"
        return 0
    else
        echo "❌ MISMATCH: Hashes differ - Build is NOT reproducible"
        return 1
    fi
}

# If called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <local-file> <official-file>"
        exit 1
    fi
    compare_files "$1" "$2"
fi