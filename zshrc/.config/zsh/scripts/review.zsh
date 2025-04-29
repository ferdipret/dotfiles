#!/usr/bin/env zsh
set -euo pipefail

# 0) Clean slate: drop any modifications & untracked files
git reset --hard HEAD
git clean -fd

# 1) Detect default branch name
if git rev-parse --verify main >/dev/null 2>&1; then
  DEFAULT=main
elif git rev-parse --verify master >/dev/null 2>&1; then
  DEFAULT=master
else
  echo "❌  Could not find a 'main' or 'master' branch locally." >&2
  exit 1
fi

# 2) Prompt (zsh style)
read "FEATURE?👉  Feature branch to review: "
read "TARGET?👉  Target branch (default: $DEFAULT): "
TARGET=${TARGET:-$DEFAULT}

REVIEW_BRANCH="review-on-${TARGET}"

# 3) Fetch latest remote branches
git fetch origin

# 4) Recreate the review branch off of origin/$TARGET
if git show-ref --quiet refs/heads/"$REVIEW_BRANCH"; then
  git branch -D "$REVIEW_BRANCH"
fi
git checkout -b "$REVIEW_BRANCH" origin/"$TARGET"

# 5) Overlay all changes from FEATURE unstaged
git diff origin/"$TARGET" origin/"$FEATURE" | git apply

echo
echo "✅  Branch '$REVIEW_BRANCH' created off origin/$TARGET"
echo "    All changes from '$FEATURE' are now in your working tree (unstaged)."
echo "    Run 'nvim .' (or your editor) to start reviewing!"

