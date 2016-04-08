#!/bin/sh
#
# To enable this hook link it into .git/hooks and with the command :
# ln -s /[project-dir]/scripts/code-quality/code-quality-pre-commit-hook.sh /[project-dir]/.git/hooks/pre-commit



# Base variables.
EXIT_CODE=0
INSTALL_DIR=`readlink -f $0 | xargs dirname`

# Binaries.
GRUNT_BIN=`command -v grunt`



# Begin Grunt hook
cd $INSTALL_DIR
$GRUNT_BIN checkCommit
EXIT_CODE=$((${EXIT_CODE} + $?))
cd -



# Errors
if [ $EXIT_CODE -ne 0 ]
then
    echo ""
    echo "Problems were found"
    echo "Commit aborted."
fi

exit ${EXIT_CODE}
