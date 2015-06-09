#!/bin/sh
#
# To enable this hook copy it into .git/hooks and rename it pre-commit :
# cp scripts/code-quality/code-quality-pre-commit-hook.sh .git/hooks/pre-commit



# Base variables.
EXIT_CODE=0
INSTALL_DIR=`readlink -f $0 | xargs dirname`

# Binaries.
GRUNT_BIN=`command -v grunt`



# Begin Grunt hook
cd $INSTALL_DIR
$GRUNT_BIN checkCommit
cd -
EXIT_CODE=$((${EXIT_CODE} + $?))



# Errors
if [ $EXIT_CODE -ne 0 ]
then
    echo ""
    echo "Problems were found"
    echo "Commit aborted."
fi

exit ${EXIT_CODE}
