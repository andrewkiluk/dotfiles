# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="andrew-custom"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history-substring-search)

source $ZSH/oh-my-zsh.sh

source .config/fzy-key-bindings.zsh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down

#  _____            _                                      _
# | ____|_ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_
# |  _| | '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
# | |___| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_
# |_____|_| |_|\_/ |_|_|  \___/|_|_|_|_| |_| |_|\___|_| |_|\__|
# \ \   / /_ _ _ __(_) __ _| |__ | | ___  ___
#  \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#   \ V / (_| | |  | | (_| | |_) | |  __/\__ \
#    \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH=$PATH:/home/andrew/.scripts:/home/andrew/.gocode/bin:/home/andrew/.local/bin

#  ______                _   _                 
# |  ____|              | | (_)                
# | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
# |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
# | |  | |_| | | | | (__| |_| | (_) | | | \__ \
# |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                              
function name() {
	find . -name \*"$1"\* 
}

function new-alias() {
  local last_command=$(echo `history |tail -n1 |head -n1` | sed 's/[0-9]* //')
  echo alias $1="'""$last_command""'" >> ~/.zshrc
  . ~/.zshrc
}

#     _    _ _
#    / \  | (_) __ _ ___  ___  ___
#   / _ \ | | |/ _` / __|/ _ \/ __|
#  / ___ \| | | (_| \__ \  __/\__ \
# /_/   \_\_|_|\__,_|___/\___||___/
#
alias plz=sudo
alias steam='LD_PRELOAD="/usr/lib32/libasound.so.2:/usr/lib/libasound.so.2" steam'
alias cmus-attach='tmux a -t cmux'
alias weather='curl wttr.in'
