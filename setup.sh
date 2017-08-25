#!/usr/bin/env bash
#
# setup.sh
# Copyright (C) 2017 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.
#

if [ "$#" != "1" ]; then
	echo "Usage: setup.sh [work dir]"
	exit
fi

WORK_DIR="$1"

OS="$(uname)"
echo "Platform: \x1b[0;32m$OS\x1b[0m"

# absolute path of current directory
if [[ "$OS" = "Darwin" ]]; then
	TMP_DIR="/tmp/$(date +%s | md5 | head -c 10)"
	SCRIPTPATH=$(realpath "$0" | xargs -0 dirname)
else
	TMP_DIR="/tmp/$(date +%s | md5sum | head -c 10)"
	SCRIPTPATH=$(readlink -f "$0" | xargs -0 dirname)
fi

ln -s "$SCRIPTPATH/dot.gitconfig" "$HOME/.gitconfig"

if [[ -d "$WORK_DIR/gdb-dashboard" ]]; then
	echo "gdb-dashboard already exists."
else
	echo "Installing gdb-dashboard..."
	git clone --depth 1 https://github.com/cyrus-and/gdb-dashboard "$WORK_DIR/gdb-dashboard"
	ln -s "$WORK_DIR/gdb-dashboard/.gdbinit" "$HOME/.gdbinit"
fi

if [[ -d "$WORK_DIR/kuoe0-vim" ]]; then
	echo "kuoe0-vim already exists." else
	echo "Settting up Vim environment..."
	git clone git@github.com:kuoe0/kuoe0-vim.git "$WORK_DIR/kuoe0-vim"
	cd "$WORK_DIR/kuoe0-vim"
	make all
fi

if [[ -d "$WORK_DIR/kuoe0-tmux" ]]; then
	echo "kuoe0-tmux already exists."
else
	echo "Settting up tmux environment..."
	git clone git@github.com:kuoe0/kuoe0-tmux.git "$WORK_DIR/kuoe0-tmux"
	cd "$WORK_DIR/kuoe0-tmux"
	./setup.sh
fi

if [[ -d "$WORK_DIR/kuoe0-zsh" ]]; then
	echo "kuoe0-zsh already exists."
else
	echo "Setting up Zsh environment..."
	git clone git@github.com:kuoe0/kuoe0-zsh.git "$WORK_DIR/kuoe0-zsh"
	cd "$WORK_DIR/kuoe0-zsh"
	./setup.sh
fi
