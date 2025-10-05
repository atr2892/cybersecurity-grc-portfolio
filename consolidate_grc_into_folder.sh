#!/usr/bin/env bash
set -euo pipefail

APPLY="${APPLY:-0}"
BRANCH="grc-consolidate-$(date +%Y%m%d-%H%M)"
TARGET="GRC-Projects"

# Root-level folders that should live under GRC-Projects/
GRC_DIRS=(
  "Incident-Response-and-Runbooks"
  "Policy-and-Compliance-Documents"
  "Splunk-Detection-and-Controls"
  "Vulnerability-Risk-Assessment"
  "Cloud Administration"
)

log(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
run(){ if [[ "$APPLY" -eq 1 ]]; then eval "$*"; else echo "(dry-run) $*"; fi; }

ensure_root(){
  [[ -d .git ]] || { echo "Run this from your repo root (where .git lives)"; exit 1; }
}

is_tracked(){ git ls-files --error-unmatch "$1" >/dev/null 2>&1; }

# Move one path (file/dir) with git mv if tracked, else mv
mv_one(){
  local src="$1" dst="$2"
  run "mkdir -p \"$(dirname "$dst")\""
  if [[ "$APPLY" -eq 1 ]]; then
    if is_tracked "$src"; then git mv -f "$src" "$dst"; else mv -f "$src" "$dst"; fi
  else
    echo "(dry-run) mv -f \"$src\" \"$dst\""
  fi
}

# Remove a file if it exists (.gitkeep etc.)
rm_file_if_exists(){
  local f="$1"
  [[ -f "$f" ]] || return 0
  if [[ "$APPLY" -eq 1 ]]; then
    if is_tracked "$f"; then git rm -f "$f"; else rm -f "$f"; fi
  else
    echo "(dry-run) rm -f \"$f\""
  fi
}

# Remove dir if empty after moves
rmdir_if_empty(){
  local d="$1"
  [[ -d "$d" ]] || return 0
  if [[ -z "$(find "$d" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    if [[ "$APPLY" -eq 1 ]]; then rmdir "$d" 2>/dev/null || true
    else echo "(dry-run) rmdir \"$d\" (if empty)"; fi
  fi
}

move_all_contents(){
  local src_dir="$1" dest_dir="$2"

  # ensure dest exists; if only .gitkeep inside, remove it
  run "mkdir -p \"$dest_dir\""
  rm_file_if_exists "$dest_dir/.gitkeep"

  # move all items from src into dest (files and subdirs)
  if [[ -d "$src_dir" ]]; then
    # Use find to handle hidden files too (except . and ..)
    while IFS= read -r -d '' item; do
      base="$(basename "$item")"
      mv_one "$item" "$dest_dir/$base"
    done < <(find "$src_dir" -mindepth 1 -maxdepth 1 -print0)
  fi

  # remove source if now empty
  rmdir_if_empty "$src_dir"
}

main(){
  ensure_root
  git fetch --all --prune
  git checkout main >/dev/null 2>&1 || git checkout -B main
  git pull --ff-only || true

  if [[ "$APPLY" -eq 1 ]]; then
    git checkout -b "$BRANCH"
  else
    log "(dry-run) Would create branch $BRANCH"
  fi

  run "mkdir -p \"$TARGET\""

  for name in "${GRC_DIRS[@]}"; do
    src="$name"                 # root-level folder (where real files are)
    dest="$TARGET/$name"        # target under GRC-Projects/

    # Ensure the target exists; remove placeholder .gitkeep if present
    run "mkdir -p \"$dest\""
    rm_file_if_exists "$dest/.gitkeep"

    if [[ -d "$src" ]]; then
      log "Moving contents of '$src' -> '$dest'"
      move_all_contents "$src" "$dest"
    else
      log "No root-level '$src' folder found; skipping"
    fi

    # Also check if any duplicate copies exist elsewhere outside GRC-Projects and clean up
    mapfile -t leftovers < <(find . -type d -name "$name" -not -path "./.git/*" -not -path "./$TARGET/$name" -printf "%P\n" | sort)
    for dup in "${leftovers[@]}"; do
      [[ -z "$dup" ]] && continue
      # If any stray empty dup remains after merges, remove it safely
      if [[ -d "$dup" && -z "$(find "$dup" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
        log "Removing empty duplicate dir: $dup"
        run "rmdir \"$dup\" || true"
      fi
    done
  done

  if [[ "$APPLY" -eq 1 ]]; then
    if ! git diff --quiet; then
      git add -A
      git commit -m "Consolidate GRC content: move root-level folders into GRC-Projects/, remove placeholders"
      git push -u origin "$BRANCH"
      log "✅ Done. Branch pushed: $BRANCH (open a PR → main)."
    else
      log "No changes to commit."
    fi
  else
    log "Dry-run complete. To apply, run: APPLY=1 bash $(basename "$0")"
  fi
}

main "$@"
