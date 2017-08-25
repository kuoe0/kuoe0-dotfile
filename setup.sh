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
DOTFILE_DIR="$WORK_DIR/kuoe0-dotfile"

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

if [[ ! -d "$WORK_DIR" ]]; then
	mkdir -p "$WORK_DIR"
fi

if [[ -d "$DOTFILE_DIR" ]]; then
	echo "kuoe0-dotfile already exists!"
else
	echo "Downloading kuoe0-dotfile..."
	git clone git@github.com:kuoe0/kuoe0-dotfile.git "$DOTFILE_DIR"
fi

[[ -e "$HOME/.gitconfig" ]] && rm "$HOME/.gitconfig"
ln -s "$DOTFILE_DIR/dot.gitconfig" "$HOME/.gitconfig"

[[ -e "$HOME/.gdbinit" ]] && rm "$HOME/.gdbinit"
echo "Installing gdb-dashboard..."
git clone --depth 1 https://github.com/cyrus-and/gdb-dashboard "$DOTFILE_DIR/gdb-dashboard"
ln -s "$DOTFILE_DIR/gdb-dashboard/.gdbinit" "$HOME/.gdbinit"

echo "Settting up tmux environment..."
git clone git@github.com:kuoe0/kuoe0-tmux.git "$DOTFILE_DIR/kuoe0-tmux"
cd "$DOTFILE_DIR/kuoe0-tmux"
bash setup.sh

echo "Setting up Zsh environment..."
git clone git@github.com:kuoe0/kuoe0-zsh.git "$DOTFILE_DIR/kuoe0-zsh"
cd "$DOTFILE_DIR/kuoe0-zsh"
bash setup.sh

echo "Settting up Vim environment..."
git clone git@github.com:kuoe0/kuoe0-vim.git "$DOTFILE_DIR/kuoe0-vim"
cd "$DOTFILE_DIR/kuoe0-vim"
make all
