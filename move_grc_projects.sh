#!/usr/bin/env bash
set -euo pipefail

APPLY="${APPLY:-0}"
BRANCH="grc-projects-rehome-$(date +%Y%m%d-%H%M)"
TARGET="GRC-Projects"
GRC_DIRS=(
  "Incident-Response-and-Runbooks"
  "Policy-and-Compliance-Documents"
  "Splunk-Detection-and-Controls"
  "Vulnerability-Risk-Assessment"
  "Cloud Administration"
)

log(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
run(){ if [[ "$APPLY" -eq 1 ]]; then eval "$*"; else echo "(dry-run) $*"; fi; }
ensure_root(){ [[ -d .git ]] || { echo "Run this from the repo root"; exit 1; }; }
is_tracked(){ git ls-files --error-unmatch "$1" >/dev/null 2>&1; }

mv_safe(){ # mv_safe <src> <dst>
  local src="$1" dst="$2"
  run "mkdir -p \"$(dirname "$dst")\""
  if [[ "$APPLY" -eq 1 ]]; then
    if is_tracked "$src"; then git mv -f "$src" "$dst"; else mv -f "$src" "$dst"; fi
  else
    echo "(dry-run) mv -f \"$src\" \"$dst\""
  fi
}

rm_safe(){ # rm_safe <path>
  local p="$1"
  [[ -e "$p" ]] || return 0
  if [[ "$APPLY" -eq 1 ]]; then
    if is_tracked "$p"; then git rm -r -f "$p"; else rm -rf "$p"; fi
  else
    echo "(dry-run) rm -rf \"$p\""
  fi
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

  run "mkdir -p \"$TARGET/tools\""

  # Move helper script(s) into tools/
  for helper in "grc_link.sh" "grc_linkup.sh"; do
    if [[ -f "$helper" ]]; then
      log "Moving helper $helper -> $TARGET/tools/$helper"
      mv_safe "$helper" "$TARGET/tools/$helper"
    fi
  done

  # Rehome GRC directories
  for name in "${GRC_DIRS[@]}"; do
    log "Processing: $name"

    # Replace any existing copy inside target
    if [[ -d "$TARGET/$name" ]]; then
      log "  > Removing existing $TARGET/$name (will replace with latest)"
      rm_safe "$TARGET/$name"
    fi

    # Find all copies outside .git
    mapfile -t matches < <(find . -type d -name "$name" -not -path "./.git/*" -printf "%P\n" | sort)

    if [[ "${#matches[@]}" -eq 0 ]]; then
      log "  > WARNING: No folder named '$name' found."
      continue
    fi

    # Choose one to move into target (prefer repo-root copy if present)
    chosen=""
    for m in "${matches[@]}"; do
      [[ "$m" == "$TARGET/$name" ]] && continue
      if [[ "$m" == "$name" ]]; then chosen="$m"; break; fi
      [[ -z "$chosen" ]] && chosen="$m"
    done

    if [[ -n "$chosen" ]]; then
      log "  > Moving '$chosen' -> '$TARGET/$name'"
      mv_safe "$chosen" "$TARGET/$name"
    else
      log "  > Only instance is already inside $TARGET"
    fi

    # Remove any other duplicates still outside GRC-Projects
    mapfile -t leftovers < <(find . -type d -name "$name" -not -path "./.git/*" -not -path "./$TARGET/$name" -printf "%P\n" | sort)
    for dup in "${leftovers[@]}"; do
      [[ -z "$dup" ]] && continue
      log "  > Removing duplicate outside $TARGET: $dup"
      rm_safe "$dup"
    done
  done

  if [[ "$APPLY" -eq 1 ]]; then
    if ! git diff --quiet; then
      git add -A
      git commit -m "Rehome all GRC folders into GRC-Projects/, replace existing, remove duplicates; move grc_link helper into tools/"
      git push -u origin "$BRANCH"
      log "✅ Done. Branch pushed: $BRANCH (open a PR → main)."
    else
      log "No changes to commit."
    fi
  else
    log "Dry-run complete. To apply changes: APPLY=1 bash $(basename "$0")"
  fi
}

main "$@"
