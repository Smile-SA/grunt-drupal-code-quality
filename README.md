# Code quality

## Description

Code quality tools for Drupal 8.



## Prerequisites

### Curl

Linux instructions (need sudo) :
```shell
apt-get install curl
```


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

Linux instructions (need sudo) :
```shell
npm install -g grunt-cli
```



## Deploying a new project

### Using installer

Installation command :
```shell
\curl -sSL http://cdn.rawgit.com/tonai/code-quality/master/installer.sh | bash -s master
```

You can use an other branch or tag instead of using "master" :
```shell
\curl -sSL http://cdn.rawgit.com/tonai/code-quality/master/installer.sh | bash -s v0.0.3
```


### Options

You can append options to the previous commands :
* `--project-dir=<dir>`  
  Specify the location of the project used for running quality tools.  
  By default it is equal to the current directory when launching the installation.
    
* `--install-dir=<dir>`  
  Specify the installation directory of the code quality tools.  
  By default it is equal to `./scripts/code-quality`.

* `--git-hooks-dir=<dir>`  
  Specify the location of the Git hooks directory.  
  By default it is equal to `./.git/hooks`.

* `--no-git`  
  Use this option if don't use Git or if you don't want the pre-commit hook to be installed.

Example :
```shell
\curl -sSL http://cdn.rawgit.com/tonai/code-quality/master/installer.sh | bash -s master --project-dir=src
```



## Running tests

Tests will automatically run when you commit if you have enabled the GIt hook, but if you want to run them manually you can do the following :
```shell
grunt --base src --gruntfile scripts/code-quality/Gruntfile.js
```

* `--base` : refer to your project directory you want to run code quality tools on.
* `--gruntfile` : refer to the Gruntfile.js file located in the code quality installation directory.

[node]: https://nodejs.org/
[grunt]: http://gruntjs.com/



## Release History

See the [CHANGELOG.txt](https://github.com/tonai/code-quality/blob/master/CHANGELOG.txt)
