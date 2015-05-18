# Code quality

## Description

Code quality tools for Drupal 8.



## Prerequisites

### Node

#### Node for Linux

Download sources :
```shell
cd /root
wget http://nodejs.org/dist/v0.12.3/node-v0.12.3-linux-x64.tar.gz
tar xzf node-v0.12.3-linux-x64.tar.gz
rm node-v0.12.3-linux-x64.tar.gz
ln -s /root/node-v0.12.3-linux-x64/bin/node /usr/bin/node
ln -s /root/node-v0.12.3-linux-x64/bin/npm /usr/bin/npm
```

#### Node for Windows

Download and install through [installer](http://nodejs.org/download/).


### Grunt

Install grunt command with npm globally :
```shell
(sudo) npm install -g grunt-cli
```



## Deploying a new project

### Adding the code quality tools to your GIT project

Install code-quality project :
```shell
cd [my_project]
mkdir -p scripts/code-quality
git archive --format=tar --remote git@git.smile.fr:drupal/code-quality.git master | tar -x -C scripts/code-quality
git add scripts/code-quality/*
git commit -m "Add code quality tools."
git push
```

### Installing code quality tools dependencies

Install code-quality dependences :
```shell
cd [my_project]/scripts/code-quality
npm install
```

### Installing the GIT pre-commit hook

Copy the hook :
```shell
cd [my_project]
cp scripts/code-quality/code-quality-pre-commit-hook.sh .git/hooks/pre-commit
```
