#!/bin/bash

# This script nukes all repo history and rebuilds it from scratch.
# It first sets up an empty repo, adds the readme, force pushes this
# empty repo to GitHub, removes all remote tags, and then runs
# the trigger script.

TRIGGER_SCRIPT="./trigger_jobs.sh"
if [ ! -x "${TRIGGER_SCRIPT}" ]; then
    echo "Missing trigger script '${TRIGGER_SCRIPT}'! Exiting.."
    exit 1
fi

GITDIR=$(mktemp -d /tmp/dsdXXXX)
cd "${GITDIR}"
ls -la

cat > README.md << EOF
DeployStudioDiffs
-----------------

Tracking changes to DeployStudio stable and nightly versions since 1.6.3.

This is done somewhat by brute force, by checking in the entire DeployStudio Admin.app into this Git repo. The Admin app includes the Runtime and Assistant apps (and their scripts) and the server binary itself.

Each release is added as a single, tagged commit. You can simply compare by commits or compare across tags. It's possible that if the git-tracked files pattern is later updated, that the entire repo's history will have tone rebuilt, so it's recommended to share any comparison URLs using tags instead of commit hashes, which may change some time in the future.

For example, to compare 1.6.4-NB140227 to 1.6.4-NB140303, just refer to these release names prepended with a 'v':

[https://github.com/n8felton/DeployStudioDiffs/compare/v1.6.4-NB140227...v1.6.4-NB140303](https://github.com/n8felton/DeployStudioDiffs/compare/v1.6.4-NB140227...v1.6.4-NB140303)

EOF

git init
git remote add origin https://github.com/n8felton/DeployStudioDiffs
git add README.md
git commit -m "Readme"
git push --force origin master

# # clear all remote tags
git ls-remote --tags origin | awk '{print ":" $2}' | xargs git push origin)

# # start the jobs
"${TRIGGER_SCRIPT}"
