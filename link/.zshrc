export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/v18.18.0/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/System/Cryptexes/App/usr/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/bin:$PATH"
export PATH="/usr/sbin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.zig:$PATH"
export PATH="/usr/local/share/dotnet/:$PATH"

export EDITOR='nvim'

eval "$(starship init zsh)"

alias ls='colorls'
alias vim='nvim'
# alias clear='clear && fortune | cowsay'

fortune | cowsay

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "/Users/ayamatsu/.bun/_bun"

include () {
    [[ -f "$1" ]] && source "$1"
}

include ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
include ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
