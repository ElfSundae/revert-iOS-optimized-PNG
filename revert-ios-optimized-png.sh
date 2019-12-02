#!/bin/bash
set -euo pipefail

usage()
{
    cat <<EOT
Revert iOS optimized PNG to a PNG readable on other platforms.
* Xcode is required.

Usage: $(basename "$0") file|dir
EOT
}

if [[ $# != 1 ]]; then
    usage
    exit 1
fi

OUTPUT=revertedPNGs
pngcrush=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush

if [[ ! -x "$pngcrush" ]]; then
    echo "Xcode is not installed."
    exit 1
fi

if [[ -f "$1" ]]; then
    "$pngcrush" -q -revert-iphone-optimizations -d "$OUTPUT" "$1"
    if [[ $? == 0 ]]; then
        echo "Output: $OUTPUT/$1"
    else
        echo "Error"
        exit 2
    fi
elif [[ -d "$1" ]]; then
    find "${1%/}" -type f -name "*.png" \
        -exec "$pngcrush" -q -revert-iphone-optimizations -d "$OUTPUT" {} \;
    echo "Output: $OUTPUT"
else
    echo "Error: $1 is not a file or directory path."
    exit 1
fi
