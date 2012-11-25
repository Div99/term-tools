#!/bin/bash
set -e

if command -v git >/dev/null 2>&1; then
	echo "git: exists"
elif command -v apt-get >/dev/null 2>&1; then
	# ubuntu
	sudo apt-get install -y git-all
elif command -v /opt/local/bin/port >/dev/null 2>&1; then
	# macports
	sudo port clean git-core
	sudo port selfupdate
	sudo port install                       git-core +svn+bash_completion+mp_completion
	sudo port -n upgrade --enforce-variants git-core +svn+bash_completion+mp_completion
else
	echo "ERROR: git is not installed"
	exit 1
fi

# store git user info
FIX_GIT_USER=~/term-tools/fix-git-user.sh
git config -l | grep "^user" | sed 's/^/git config --global /' | sed 's/=/ "/' | sed 's/$/"/' > $FIX_GIT_USER

# use template
cp -f ~/term-tools/config/gitconfig-template ~/term-tools/config/gitconfig

# this will fail if it already exists, so we are safe
ln $@ -s ~/term-tools/config/gitconfig ~/.gitconfig

source $FIX_GIT_USER
rm $FIX_GIT_USER

