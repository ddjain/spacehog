#!/usr/bin/env bash
# Surveys common cache/build/download directories and reports what's taking
# up space, sorted largest first. Read-only — deletes nothing.
#
# Works on macOS and Linux; macOS-only sections (Library/Caches, Xcode,
# Docker.app container) are skipped with a note on other platforms.
#
# Usage: spacehog.sh [--top N] [--node-modules-root DIR] [--depth N]

set -uo pipefail

TOP_N=25
SCAN_ROOT="$HOME"
NODE_MODULES_DEPTH=6
IS_MACOS=false
[[ "$(uname -s)" == "Darwin" ]] && IS_MACOS=true

usage() {
  cat <<'EOF'
Usage: spacehog.sh [options]

Read-only disk usage survey of common cache/build/download directories.

Options:
  --top N                  Items to show per section (default: 25)
  --node-modules-root DIR  Root to search for node_modules (default: $HOME)
  --depth N                Max search depth for node_modules (default: 6)
  -h, --help                Show this help and exit
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --top) TOP_N="$2"; shift 2 ;;
    --node-modules-root) SCAN_ROOT="$2"; shift 2 ;;
    --depth) NODE_MODULES_DEPTH="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 1 ;;
  esac
done

hr() { printf '%.0s-' {1..70}; echo; }

section() {
  echo
  hr
  echo "$1"
  hr
}

du_sorted() {
  local paths=("$@")
  local existing=()
  for p in "${paths[@]}"; do
    [[ -e "$p" ]] && existing+=("$p")
  done
  if [[ ${#existing[@]} -eq 0 ]]; then
    echo "  (none found)"
    return
  fi
  du -sh "${existing[@]}" 2>/dev/null | sort -rh
}

echo "Disk analysis for $(whoami)@$(hostname) — $(date)"

section "Overall volume usage (df -h /)"
df -h /

section "Top-level home cache directories"
du_sorted "$HOME/Library/Caches" "$HOME/.cache" "$HOME/Downloads" "$HOME/.Trash"

section "Package manager / build caches"
du_sorted \
  "$HOME/.cache/uv" \
  "$HOME/.cache/pip" \
  "$HOME/Library/Caches/pip" \
  "$HOME/.npm" \
  "$HOME/Library/Caches/Yarn" \
  "$HOME/Library/Caches/Homebrew" \
  "$HOME/Library/Caches/go-build" \
  "$HOME/Library/Caches/node-gyp" \
  "$HOME/Library/Caches/pyright-python" \
  "$HOME/Library/Caches/ms-playwright" \
  "$HOME/.cargo/registry" \
  "$HOME/.gradle/caches" \
  "$HOME/.m2/repository"

section "ML model caches"
du_sorted \
  "$HOME/.cache/huggingface" \
  "$HOME/.cache/whisper" \
  "$HOME/.cache/torch" \
  "$HOME/.ollama/models" \
  "$HOME/.lmstudio/models"

if $IS_MACOS; then
section "Individual items in ~/Library/Caches (top $TOP_N)"
du -sh "$HOME/Library/Caches"/* 2>/dev/null | sort -rh | head -n "$TOP_N"
else
section "~/Library/Caches (macOS only — skipped)"
fi

section "Individual items in ~/.cache (top $TOP_N)"
du -sh "$HOME/.cache"/* 2>/dev/null | sort -rh | head -n "$TOP_N"

section "Individual items in ~/Downloads (top $TOP_N)"
du -sh "$HOME/Downloads"/* 2>/dev/null | sort -rh | head -n "$TOP_N"

section "Docker (if running)"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker system df
else
  echo "  Docker daemon not running or docker not installed."
  if $IS_MACOS; then
    du -sh "$HOME/Library/Containers/com.docker.docker" 2>/dev/null
  fi
fi

section "node_modules under $SCAN_ROOT (top $TOP_N, excludes nested ones, depth $NODE_MODULES_DEPTH)"
find "$SCAN_ROOT" -maxdepth "$NODE_MODULES_DEPTH" -name node_modules -type d \
  -not -path "*/node_modules/*/node_modules*" 2>/dev/null \
  -exec du -sh {} \; 2>/dev/null | sort -rh | head -n "$TOP_N"

if $IS_MACOS; then
section "Xcode / iOS developer caches (if present)"
du_sorted \
  "$HOME/Library/Developer/Xcode/DerivedData" \
  "$HOME/Library/Developer/Xcode/Archives" \
  "$HOME/Library/Developer/CoreSimulator/Caches" \
  "$HOME/Library/Developer/CoreSimulator/Devices"
else
section "Xcode developer caches (macOS only — skipped)"
fi

echo
hr
echo "Done. This script is read-only — nothing was deleted."
hr
