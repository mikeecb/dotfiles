source ~/antigen.zsh
antigen use oh-my-zsh
# Setup a pretty theme
antigen theme robbyrussell
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
# Tell Antigen that you're done.
antigen apply

# Make sure vim and tmux colorschemes match
export TERM=xterm-256color

# Set up Go path
export GOPATH=$(go env GOPATH)
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org

# Add RVM path
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Add local bin path
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/bin/platform-tools"
export PATH="$PATH:/Users/mcypher/Library/Python/3.7/bin"
export PATH="$PATH:/usr/local/Cellar/dex2jar/2.0/bin"

# Add yarn path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Setup FZF
export FZF_DEFAULT_OPTS="--height 30% --border"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# See https://www.growingwiththeweb.com/2018/01/slow-nvm-init.html
# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
    # Call `nvm use` automatically in a directory with a .nvmrc file
    # Must call after initializing nvm
    autoload -U add-zsh-hook
    load-nvmrc() {
      local node_version="$(nvm version)"
      local nvmrc_path="$(nvm_find_nvmrc)"

      if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
          nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
          nvm use
        fi
      elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
      fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi


source ~/.work
source ~/.secrets

# Use neovim instead of vim
alias vim=nvim
alias vi=nvim
alias v=nvim

# Use fd instead of find
alias find=fd
alias f=fd

# Use ripgrep instead of grep or ag (silver surfer)
alias grep=rg
alias ag=rg
alias g=rg

# Other better alternatives
alias cat=bat
alias curl=http
alias du=dust
alias ls=exa
alias ps=procs
alias sed=sd
alias time=hyperfine
