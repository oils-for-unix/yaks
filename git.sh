#!/usr/bin/env bash
#
# Usage:
#   ./git.sh <function name>

set -o nounset
set -o pipefail
set -o errexit

log-master() {
  git log main..
}

diff-master() {
  git diff main..
}

rebase-master() {
  git rebase -i main
}

merge-to-master() {
  local do_push=${1:-T}  # pass F to disable

  local branch=$(git rev-parse --abbrev-ref HEAD)

  if test "$do_push" = T; then
    git checkout main &&
    git merge $branch &&
    git push &&
    git checkout $branch
  else
    git checkout main &&
    git merge $branch &&
    git checkout $branch
  fi
}

"$@"
