# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "$(which brew)" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
# Add in snippets
if [[ -f "$(which git)" ]] then
  zinit snippet OMZP::git
fi

if [[ -f "$(which docker)" ]] then
  zinit snippet OMZP::docker
  # zinit snippet OMZP::docker-compose
fi

NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
if [[ -d "${NVM_DIR}" ]] then
 zinit snippet OMZP::nvm
fi

if [[ -f "$(which pyenv)" ]] then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  zinit snippet OMZP::pyenv
fi

if [[ -f "$(which aws)" ]] then
  zinit snippet OMZP::aws
  alias awslocal="aws --endpoint-url=http://localhost:4566"
  alias sts="aws sts get-caller-identity"
fi

# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

fpath+=${HOME}/.cache/zinit/completions
autoload -Uz compinit && compinit

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# load editor
export EDITOR=vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Key Bindings
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^u" backward-kill-line
bindkey "^y" yank


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Aliases
alias ls='ls --color'

# Shell integrations

fzf_eval=$(fzf --zsh 2>/dev/null)
if [ $? -eq 0 ]; then
  eval $fzf_eval
else
  if [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

eval "$(zoxide init --cmd cd zsh)"

src () {set -a; . $1; set +a}
export -f src > /dev/null 2>&1

# System specific configurations
if [ ! -d ${HOME}/.zsh.d ]; then
  mkdir ${HOME}/.zsh.d
fi

find ${HOME}/.zsh.d -name '*.zsh' -type f | while read -r f; do
  source $f
done

