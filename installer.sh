#!/bin/bash

########## Variables initialization ##########

# Base variables.
EXIT_CODE=0
NODE_MIN_VERSION=0.8.0

# Default variables initialization.
INSTALL_DIR=./scripts/code-quality
GIT_HOOKS_DIR=./.git/hooks
INSTALL_GIT_HOOK=1

# Retrieve options.
for VAR in "$@"
do
    case $VAR in
        info|help|-h )
            echo "Usage: ./`basename $0` [options]"
            echo ""
            echo "  * option '--install-dir' :"
            echo "    Specify the installation directory of the code quality tools."
            echo "    By default it is equal to './scripts/code-quality'."
            echo "    Example : --install-dir=/root/code-quality"
            echo ""
            echo "  * option '--git-hooks-dir' :"
            echo "    Specify the location of the Git hooks directory."
            echo "    By default it is equal to './.git/hooks'."
            echo "    Example : --git-hooks-dir=my_project/.git/hooks"
            echo ""
            echo "  * option '--no-git' :"
            echo "    Use this option if don't use Git or if you don't want the pre-commit hook to be installed."
            echo ""
            exit 0;;
        --no-git )
            INSTALL_GIT_HOOK=0;;
        --install-dir* )
           INSTALL_DIR=$(echo $VAR | cut -d "=" -f 2);;
        --git-hooks-dir* )
            GIT_HOOKS_DIR=$(echo $VAR | cut -d "=" -f 2);;
        * )
            echo "Unknown argument '$VAR'.";;
    esac
done



########## Utilities ##########

verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}



########## Check requirements ##########

# Check node.
NODE_BIN=`command -v node`
EXIT_CODE=$((${EXIT_CODE} + $?))
if [ -z $NODE_BIN ]
then
  echo "node was not found."
else
    # Check version.
    NODE_VERSION=`$NODE_BIN --version | cut -c2-`
    verlte $NODE_MIN_VERSION $NODE_VERSION || { ((EXIT_CODE++)); echo "node version >= $NODE_MIN_VERSION is required."; }
fi

# Check grunt.
GRUNT_BIN=`command -v grunt`
EXIT_CODE=$((${EXIT_CODE} + $?))
if [ -z $GRUNT_BIN ]
then
    echo "grunt was not found."
fi

# Exits if problems were detected.
test $EXIT_CODE -gt 0 && { echo "Aborting."; exit ${EXIT_CODE}; }
echo "Continuing installation...";



########## Start installation ##########

# Transform relative to absolute path.
INSTALL_DIR=`readlink -f $INSTALL_DIR`
GIT_HOOKS_DIR=`readlink -f $INSTALL_DIR`

# Download and extract archive.
wget https://github.com/tonai/code-quality/archive/master.tar.gz
tar -xf master.tar.gz
mv Code-quality-master $INSTALL_DIR
rm -f master.tar.gz

# Install dependencies
cd $INSTALL_DIR
npm install
cd -

# Install GIT pre-commit hook.
if [ $INSTALL_GIT_HOOK -eq 1 ]
then
    ln -s $INSTALL_DIR/code-quality-pre-commit-hook.sh $GIT_HOOKS_DIR/pre-commit
fi
