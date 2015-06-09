# Code quality

## Description

Code quality tools for Drupal 7.

This project provides the following tools for checking your code against the [Drupal coding standards](https://www.drupal.org/coding-standards) and other best practices :
* PHP_CodeSniffer
* PHP Mess Detector
* ESLint
* CSS Lint



## Prerequisites

### Curl

Linux instructions (need sudo) :
```shell
apt-get install curl
```


### [Composer][composer]

Install composer globally :
```shell
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
```

If not, the installer script will install composer locally within the code quality directory.


### [Node][node]

node >= `0.8.0` is required.

Linux instructions for 64 bits (need sudo) :
```shell
cd /usr/local
wget http://nodejs.org/dist/v0.12.3/node-v0.12.3-linux-x64.tar.gz
tar xzf node-v0.12.3-linux-x64.tar.gz
rm node-v0.12.3-linux-x64.tar.gz
ln -s /root/node-v0.12.3-linux-x64/bin/node /usr/bin/node
ln -s /root/node-v0.12.3-linux-x64/bin/npm /usr/bin/npm
```


### [Grunt][grunt]

grunt-cli >= `0.1.12` is required.

Linux instructions (need sudo) :
```shell
npm install -g grunt-cli
```



## Deploying a new project

### Using installer

The simplest way is to go into your project root directory, where the `.git` folder is located, and run the following command :
```shell
curl -sSL http://cdn.rawgit.com/tonai/code-quality/7.x-1.x/installer.sh | bash -s 7.x-1.x
```

You can use git tags instead of a branch name :
```shell
curl -sSL http://cdn.rawgit.com/tonai/code-quality/7.x-1.x/installer.sh | bash -s v7.0.1
```

By default the code quality tools will be installed in the following directory : `./scripts/code-quality`

You can change this by appending options at the end of the command. See below for an explanation of available options.


### Options

You can append options to the previous commands :
* `--project-dir=<dir>`
  Specify the location of the project used for running quality tools.
  By default it is equal to the current directory when launching the installation (`.`).

* `--install-dir=<dir>`
  Specify the installation directory of the code quality tools.
  By default it is equal to `./scripts/code-quality`.

* `--work-tree=<dir>`
  Specify the location of the Git working tree.
  By default it is equal to the current directory when launching the installation (`.`).

* `--git-dir=<dir>`
  Specify the location of the Git directory.
  By default it is equal to `./.git`.

* `--no-git`
  Use this option if don't use Git or if you don't want the pre-commit hook to be installed.

Example :
```shell
curl -sSL http://cdn.rawgit.com/tonai/code-quality/7.x-1.x/installer.sh | bash -s 7.x-1.x --project-dir=src
```


### Manual installation

Download and extract this repository in the folder you want (usually a subfolder in your own Git project).

Go inside the extracted directory and install dependencies :
```shell
npm install
composer install
```

Install PHPCS profile :
```shell
./vendor/bin/phpcs --config-set installed_paths `readlink -f ./vendor/drupal/coder/coder_sniffer`
```

Then create a file named `env.json` containing the following absolute paths :
* projectDir : absolute path to the directory containing the sources you want to lint
* workTree : absolute path to your project Git working tree
* gitDir : absolute path to your project `.git` directory

Example :
```json
{
  "projectDir":"/home/me/my_project/src",
  "workTree":"/home/me/my_project",
  "gitDir":"/home/me/my_project/.git"
}
```

Finally install the Git hook by copying the file named `code-quality-pre-commit-hook.sh` in the `.git/hooks/` directory and rename that file `pre-commit`.



## Running tests

Tests will automatically run when you commit if you have enabled the GIt hook, but if you want to run them manually you can do the following :
```shell
grunt --base src --gruntfile scripts/code-quality/Gruntfile.js
```

* `--base` : refer to your project directory you want to run code quality tools on.
* `--gruntfile` : refer to the Gruntfile.js file located in the code quality installation directory.



## Release History

See the [CHANGELOG.txt](https://github.com/tonai/code-quality/blob/7.x-1.x/CHANGELOG.txt)



[composer]: https://getcomposer.org/download/
[node]: https://nodejs.org/
[grunt]: http://gruntjs.com/
