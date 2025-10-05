#!/usr/bin/env bash
set -euo pipefail

# Fix: if a file exists where a dir should be, convert it to README.md inside the dir
fix_path(){
  local p="$1"
  if [[ -f "$p" ]]; then
    tmp="${p//\//-}.tmp"
    git mv "$p" "$tmp" 2>/dev/null || mv "$p" "$tmp"
    mkdir -p "$(dirname "$p")/$(basename "$p")"
    dir="$(dirname "$p")/$(basename "$p")"
    mv "$tmp" "$dir/README.md"
    echo "Fixed file→dir collision at: $p"
  fi
}

fix_path "GRC-Projects/Cloud Administration"

APPLY=1 bash consolidate_grc_into_folder.sh
