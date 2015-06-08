#!/bin/bash

########## Help ##########
usage()
{
  printf "%b" "
Usage :
  installer.sh [action] [options]

Options :
  --project-dir=<dir>
    Specify the location of the project used for running quality tools.
    By default it is equal to the current directory when launching the installation.
    Example : --project-dir=src

  --install-dir=<dir>
    Specify the installation directory of the code quality tools.
    By default it is equal to './scripts/code-quality'.
    Example : --install-dir=/root/code-quality

  --git-hooks-dir=<dir>
    Specify the location of the Git hooks directory.
    By default it is equal to './.git/hooks'.
    Example : --git-hooks-dir=my_project/.git/hooks

  --no-git
    Use this option if don't use Git or if you don't want the pre-commit hook to be installed.

Actions :
  * help     - Displays this output.
  * <branch> - Installs from the given branch.
  * <tag>    - Installs from the given tag.

"
}



########## Variables initialization ##########

# Base variables.
EXIT_CODE=0
NODE_MIN_VERSION=0.8.0

# Default variables initialization.
GIT_BRANCH=8.x-1.x
PROJECT_DIR=.
INSTALL_DIR=./scripts/code-quality
GIT_HOOKS_DIR=./.git/hooks
INSTALL_GIT_HOOK=1

# Retrieve options.
for VAR in "$@"
do
    case $VAR in
        --no-git )
            INSTALL_GIT_HOOK=0;;
        --project-dir* )
            PROJECT_DIR=$(echo $VAR | cut -d "=" -f 2);;
        --install-dir* )
            INSTALL_DIR=$(echo $VAR | cut -d "=" -f 2);;
        --git-hooks-dir* )
            GIT_HOOKS_DIR=$(echo $VAR | cut -d "=" -f 2);;
        help )
            usage; exit 0;;
        * )
            GIT_BRANCH=$VAR;;
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

# Check composer.
COMPOSER_BIN=`command -v composer` || echo "composer was not found : it will be installed locally.";

# Check node.
NODE_BIN=`command -v node` || { ((EXIT_CODE++)); echo "node was not found."; }
if [ ! -z $NODE_BIN ]
then
    # Check version.
    NODE_VERSION=`$NODE_BIN --version | cut -c2-`
    verlte $NODE_MIN_VERSION $NODE_VERSION || { ((EXIT_CODE++)); echo "node version >= $NODE_MIN_VERSION is required."; }
fi

# Check grunt.
GRUNT_BIN=`command -v grunt` || { ((EXIT_CODE++)); echo "grunt was not found."; }

# Exits if problems were detected.
test $EXIT_CODE -gt 0 && { echo "Aborting."; exit ${EXIT_CODE}; }



########## Start installation ##########

# Create target directory.
mkdir -p $INSTALL_DIR

# Transform relative path to absolute path.
PROJECT_DIR=`readlink -f $PROJECT_DIR`
INSTALL_DIR=`readlink -f $INSTALL_DIR`
GIT_HOOKS_DIR=`readlink -f $GIT_HOOKS_DIR`

# Download and extract archive.
echo "Downloading archive."
wget https://github.com/tonai/code-quality/archive/$GIT_BRANCH.tar.gz || { echo "Given tag or branch does not exist."; exit 1; }
tar -xf $GIT_BRANCH.tar.gz
find Code-quality-$GIT_BRANCH -maxdepth 1 -mindepth 1 -type f -exec mv {} $INSTALL_DIR \;
rmdir Code-quality-$GIT_BRANCH
rm -f $GIT_BRANCH.tar.gz

# Create environment files containing data for hook.
touch $INSTALL_DIR/env.cfg
echo "PROJECT_DIR=$PROJECT_DIR" >> $INSTALL_DIR/env.cfg

# Installing composer dependencies
cd $INSTALL_DIR
if [ -z $COMPOSER_BIN ]
then
    echo "Installing composer and dependencies..."
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install
else
    echo "Installing composer dependencies..."
    $COMPOSER_BIN install
fi
CODER_DIR=`readlink -f ./vendor/drupal/coder/coder_sniffer`
./vendor/bin/phpcs --config-set installed_paths $CODER_DIR
cd -

# Install dependencies
echo "Installing project dependencies..."
cd $INSTALL_DIR
npm install
cd -

# Install GIT pre-commit hook.
if [ $INSTALL_GIT_HOOK -eq 1 ]
then
    ln -s $INSTALL_DIR/code-quality-pre-commit-hook.sh $GIT_HOOKS_DIR/pre-commit
fi

echo "Done."
