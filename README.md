Collection of my dotfiles.

* vimrcnew - development vim
* vimrc - heavily optimized for DPhil thesis writing
* runcoms - symlink this into .zprezto for zsh fun


## Installation of VIM and Tmux

ln -s ~/dotfiles/vimrc .vimrc
ln -s ~/dotfiles/dottmux.conf .tmux.conf


## Installation of ZSH / Prezto

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

mv ~/.zprezto/runcoms ~/.zprezto/orig_runcoms
cd .zprezto
ln -s ~/dotfiles/runcoms .

```sh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

## Installation of Solarized

git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
./install.sh

(Choose light, skip dircolors)
