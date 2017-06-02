# Inspired by https://github.com/gkze/setup/blob/master/bootstrap


set -e


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


HOSTNAME="cypher"
# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "${HOSTNAME}"
sudo scutil --set HostName "${HOSTNAME}"
sudo scutil --set LocalHostName "${HOSTNAME}"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${HOSTNAME}"


#
# Do not prompt admins for sudo password and add current user to admins
#
echo '%admin ALL = (ALL) NOPASSWD:ALL' | sudo tee -a /private/etc/sudoers.d/admin
sudo dseditgroup -o edit -a "${USER}" -t user admin


#
# Dock
#
# Autohide
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock show-recents -bool false
# Icon size
defaults write com.apple.dock tilesize -int 50
# Clear out all apps from Dock
defaults write com.apple.dock persistent-apps -array
# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
# Restart Dock
killall Dock


#
# Finder
#
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Show the ~/Library folder
chflags nohidden ~/Library
# Show the /Volumes folder
sudo chflags nohidden /Volumes


# Symlink dotfiles in this folder to the HOME folder
PWD=`pwd`
rm -rf ~/.config/nvim  && ln -s ${PWD}/nvim ~/.config/nvim
rm -f ~/.tmux.conf     && ln -s ${PWD}/.tmux.conf ~
rm -f ~/.tmuxline.conf && ln -s ${PWD}/.tmuxline.conf ~
rm -f ~/.zshrc         && ln -s ${PWD}/.zshrc ~
rm -rf ~/.ctags.d      && ln -s ${PWD}/.ctags.d ~
rm -f ~/.gitignore     && ln -s ${PWD}/.gitignore ~
rm -f ~/antigen.zsh    && ln -s ${PWD}/antigen.zsh ~


# Install fuzzy-find tool if it does not already exist
rm -rf ~/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf


#
# Homebrew
#
# Install Homebrew if it does not already exist
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Install Homebrew packages if they do not already exist
brew update
cat brew.txt | xargs -I {} brew install {} || brew upgrade {}


#
# Pip
#
# Install powerline
pip3 install powerline-status --user


#
# Vim
#
# Install yarn and node so that coc.nvim works
curl -sL install-node.now.sh/lts | sh
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
# Download plug.vim and put it in the "autoload" directory.
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
