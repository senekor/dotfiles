#!/bin/bash
set -euo pipefail

# This script is turns a pure jj repo into a colocated one.
# The purpose is to use git submodules, which jj just ignores at the moment.
# Therefore, to put submodules into their correct state, git is needed.
#
# yoinked from:
# https://martinvonz.github.io/jj/v0.17.1/git-compatibility/#converting-a-repo-into-a-co-located-repo

cd "$(jj root)"

# Move the Git repo
mv .jj/repo/store/git .git
# Tell jj where to find it
echo -n '../../../.git' > .jj/repo/store/git_target
# Ignore the .jj directory in Git
echo '/*' > .jj/.gitignore
# Make the Git repository non-bare and set HEAD
git config --unset core.bare
jj new @-
