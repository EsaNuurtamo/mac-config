# dotfiles

## Install on a new computer

Open terminal

Install homebrew and git:
````
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git
````

Clone this repo as bare repo:
````
echo ".dotfiles" >> .gitignore
git clone --bare git@github.com:EsaNuurtamo/dotfiles.git $HOME/.dotfiles
````

#### Install brew and all the applications and tools
````
sh .setup_scripts/brew.sh 
````
#### Setup gitconfig and default shell to fish
````
fish .setup_scripts/environment.fish
````
#### Add dotfiles to your home folder
````
fish .setuo_scripts/dotfiles.fish
````
### Configuring neovim

Create a symbolic link from neovim to the sandard place where VIM is installed:
`ln -s (which nvim) /usr/local/bin/vim`))
