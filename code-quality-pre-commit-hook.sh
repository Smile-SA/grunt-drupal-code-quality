#!/bin/sh
#
# To enable this hook copy it into .git/hooks and rename it pre-commit :
# cp scripts/code-quality/code-quality-pre-commit-hook.sh .git/hooks/pre-commit



# Define variables
EXIT_CODE=0
PROJECT_DIR=$(pwd)
CQ_DIR=$(pwd)/scripts/code-quality

# Binaries
GRUNT_BIN=/usr/bin/grunt



# Begin Grunt hook
cd $CQ_DIR
${GRUNT_BIN}
EXIT_CODE=$((${EXIT_CODE} + $?))



# Exit if errors
if [[ ${EXIT_CODE} -ne 0 ]]; then
    echo ""
    echo "Problems were found"
    echo "Commit aborted."
    exit ${EXIT_CODE}
fi
