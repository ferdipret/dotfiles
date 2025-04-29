#!/usr/bin/env zsh
set -e
set -u
setopt pipefail


# 1) Identify current branch
CURRENT=$(git rev-parse --abbrev-ref HEAD)

# 2) Ensure we're on a review branch
if [[ $CURRENT != review-on-* ]]; then
  echo "⚠️  Not on a 'review-on-<branch>' branch (currently on '$CURRENT')."
  echo "    Aborting cleanup."
  exit 1
fi

# 3) Derive target branch from the review branch name
TARGET=${CURRENT#review-on-}

# 4) Wipe local changes & untracked files
git reset --hard HEAD
git clean -fd

# 5) Switch back and delete the sandbox branch
git checkout "$TARGET"
git branch -D "$CURRENT"

echo "✅  Cleaned up '$CURRENT' and returned to '$TARGET'."

