#!/usr/bin/env bash
set -euo pipefail

# ============================================
# One-shot organizer for GRC portfolio labs
# - Dry-run by default. Set APPLY=1 to actually write files & commit.
# - Run from the repo root of: cybersecurity-grc-portfolio
# - Requires: bash, git, awk, sed, date, mkdir, grep
# ============================================

# -------- CONFIG: map "branch|Lab-Folder-Name" (no spaces around the pipe)
# Example given by you:
CONFIG=(
  "Add-Sniffing-Network-Traffic-lab-(redacted-screenshots-+-PDF)|Wireshark-Sniffing-Network-Traffic"
  # Add more here, e.g.:
  # "Add-Nmap-Recon-lab|Nmap-Recon"
  # "Linux-Hardening-lab|Linux-Hardening"
)

# Dry-run by default. Set APPLY=1 to do changes.
APPLY="${APPLY:-0}"

# Destination root for technical labs
DEST_ROOT="Technical-Labs"

# Commit message prefix
COMMIT_PREFIX="Organize labs:"

# README line anchor (adjust if your README layout differs)
TOP_README="README.md"
TOP_README_SECTION_REGEX='^##[[:space:]]*Technical Labs'
TOP_README_BULLET_PREFIX="  * "

# Basic README template for each lab
lab_readme_template() {
  local lab="$1"
  cat <<EOF
# ${lab} (Redacted)

**Objective:** Summarize what this lab demonstrates and what evidence is included.

## Contents
- \`docs/\` – PDF write-up, executive summary, references
- \`evidence/\` – redacted screenshots
- \`src/\` – pcaps, scripts, config files

## Quick Notes
- Key artifacts and filters go here.
- Findings and remediation notes here.
EOF
}

# ---------- Helpers
log() { printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
dry() { if [[ "$APPLY" -ne 1 ]]; then echo "(dry-run) $*"; else eval "$*"; fi; }
ensure_repo_root() {
  if [[ ! -d .git ]]; then
    echo "Error: not in a git repository root. cd into cybersecurity-grc-portfolio first." >&2
    exit 1
  fi
}

safe_path_join() { # join dest dir + filename, avoiding collisions by suffixing
  local dest_dir="$1"; shift
  local base="$1"; shift
  local path="${dest_dir}/${base}"
  if [[ -e "$path" ]]; then
    local stem="${base%.*}"
    local ext="${base##*.}"
    if [[ "$ext" == "$base" ]]; then
      # no extension
      local n=1
      while [[ -e "${dest_dir}/${stem}-${n}" ]]; do n=$((n+1)); done
      echo "${dest_dir}/${stem}-${n}"
    else
      local n=1
      while [[ -e "${dest_dir}/${stem}-${n}.${ext}" ]]; do n=$((n+1)); done
      echo "${dest_dir}/${stem}-${n}.${ext}"
    fi
  else
    echo "$path"
  fi
}

category_for() { # decide docs/evidence/src/default based on extension or hint dirs
  local p="$1"
  local f="$(basename "$p")"
  local lower="${f,,}"
  case "$lower" in
    *.pdf|*.doc|*.docx|*writeup*.md|*report*.md|*summary*.md) echo "docs"; return;;
  esac
  case "$lower" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.bmp|*.tiff) echo "evidence"; return;;
  esac
  case "$lower" in
    *.pcap|*.pcapng|*.py|*.sh|*.ps1|*.rc|*.yml|*.yaml|*.json|*.conf|*.cfg|*.rules|*.txt) echo "src"; return;;
  esac
  # Hint from parent dir names (screenshots/evidence/images -> evidence)
  local d="$(dirname "$p")"
  local dl="${d,,}"
  if [[ "$dl" == *"screenshot"* || "$dl" == *"evidence"* || "$dl" == *"images"* ]]; then
    echo "evidence"; return
  fi
  echo ""
}

update_top_readme() {
  local lab="$1"
  local lab_rel="${DEST_ROOT}/${lab}/"
  if [[ ! -f "$TOP_README" ]]; then
    log "Top README not found; skipping top-level index update."
    return
  fi

  local bullet="${TOP_README_BULLET_PREFIX}${lab} — \`${lab_rel}\`"
  if grep -Fq "$bullet" "$TOP_README"; then
    log "Top README already lists '${lab}'."
    return
  fi

  if ! grep -Eq "$TOP_README_SECTION_REGEX" "$TOP_README"; then
    log "Couldn't find '## Technical Labs' section; appending bullet at end."
    dry "printf '\n%s\n\n%s\n' '##  Technical Labs' '$bullet' >> '$TOP_README'"
    return
  fi

  # Insert the bullet right after the section header (first match)
  local tmp="$(mktemp)"
  awk -v sect="$TOP_README_SECTION_REGEX" -v bullet="$bullet" '
    BEGIN { inserted=0 }
    {
      print $0
      if (inserted==0 && $0 ~ sect) {
        print bullet
        inserted=1
      }
    }
  ' "$TOP_README" > "$tmp"

  if [[ "$APPLY" -eq 1 ]]; then
    mv "$tmp" "$TOP_README"
  else
    rm -f "$tmp"
    log "(dry-run) Would insert bullet under '## Technical Labs': $bullet"
  fi
}

copy_from_branch() {
  local branch="$1"
  local lab="$2"
  local dest_base="${DEST_ROOT}/${lab}"

  # List new/modified/renamed files vs main on the remote branch
  local files
  files="$(git diff --diff-filter=ACMR --name-only main..origin/"$branch" || true)"

  if [[ -z "$files" ]]; then
    log "No candidate files found on origin/${branch} vs main. Skipping."
    return
  fi

  log "Preparing destination folders for ${lab}"
  dry "mkdir -p '${dest_base}/docs' '${dest_base}/evidence' '${dest_base}/src'"

  # Pull blobs one-by-one using git show and place them by category
  while IFS= read -r p; do
    # Skip directories (git diff should list files only, but just in case)
    [[ -z "$p" ]] && continue
    if ! git cat-file -e "origin/${branch}:${p}" 2>/dev/null; then
      # Might be a deletion or rename source—ignore safely
      log "Skipping missing blob on origin/${branch}: ${p}"
      continue
    fi

    local base="$(basename "$p")"
    local cat; cat="$(category_for "$p")"
    local dest_dir
    if [[ -z "$cat" ]]; then dest_dir="${dest_base}"; else dest_dir="${dest_base}/${cat}"; fi

    local target; target="$(safe_path_join "$dest_dir" "$base")"

    if [[ "$APPLY" -eq 1 ]]; then
      mkdir -p "$dest_dir"
      git show "origin/${branch}:${p}" > "$target"
      log "Wrote -> $target"
    else
      log "(dry-run) Would write ${p} -> ${target}"
    fi
  done <<< "$files"

  # Ensure a per-lab README
  local lab_readme="${dest_base}/README.md"
  if [[ ! -f "$lab_readme" ]]; then
    if [[ "$APPLY" -eq 1 ]]; then
      mkdir -p "$dest_base"
      lab_readme_template "$lab" > "$lab_readme"
      log "Created ${lab_readme}"
    else
      log "(dry-run) Would create ${lab_readme}"
    fi
  else
    log "README already exists for ${lab}"
  fi

  # Update top-level README index
  update_top_readme "$lab"
}

main() {
  ensure_repo_root
  log "Fetching remotes…"
  git fetch --all --prune

  # Create a new branch for organization
  local ts; ts="$(date +'%Y%m%d-%H%M%S')"
  local work_branch="organize-labs-${ts}"

  if git rev-parse --verify "$work_branch" >/dev/null 2>&1; then
    echo "Branch ${work_branch} already exists; aborting to be safe." >&2
    exit 1
  fi

  log "Checking out main…"
  git checkout main >/dev/null 2>&1 || git checkout -B main

  log "Creating work branch: ${work_branch}"
  if [[ "$APPLY" -eq 1 ]]; then
    git checkout -b "$work_branch"
  else
    log "(dry-run) Would create branch ${work_branch}"
  fi

  # Process each configured branch -> lab mapping
  for entry in "${CONFIG[@]}"; do
    IFS='|' read -r branch lab <<< "$entry"
    log "==== Processing origin/${branch} -> ${DEST_ROOT}/${lab} ===="

    # Sanity: ensure remote branch exists
    if ! git show-ref --verify --quiet "refs/remotes/origin/${branch}"; then
      log "Remote branch not found: origin/${branch} — skipping."
      continue
    fi

    copy_from_branch "$branch" "$lab"
  done

  # Add and commit if APPLY=1
  if [[ "$APPLY" -eq 1 ]]; then
    if ! git diff --quiet; then
      git add -A
      git commit -m "${COMMIT_PREFIX} place labs into ${DEST_ROOT}/<lab> with docs/evidence/src, add READMEs, update index"
      log "Pushing ${work_branch}…"
      git push -u origin "$work_branch"
      log "✅ Done. Open a PR from '${work_branch}' into 'main'."
    else
      log "No changes to commit."
    fi
  else
    log "Dry-run complete. To apply changes, re-run with: APPLY=1 bash $0"
  fi
}

main "$@"
