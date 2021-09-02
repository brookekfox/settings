# green: 32, magenta: 35, cyan: 36, blue: 34

eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export GH_CLIENT_ID=312d4b7816233fa216fc
export GH_CLIENT_SECRET=c403f7e470a2fb5e1932f5f411a0f3453017d78d

export IG_CLIENT_ID=08ed6c1def394403bb4df9045cb1504a
export IG_CLIENT_SECRET=303db2c3687c418a8414203d349ecd54

export SC_CLIENT_ID=16496501e0593117374aa8062cad74ae
export SC_CLIENT_SECRET=8348dfe901854e52ce7a2625d1b4ad20

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Include git branch in prompt
# time fullPath (name of current branch)
# PS1='\A \[\033[1;36m\]\w\[\033[0m\]\[\033[1;35m\] $(__git_ps1 " (%s)")\[\033[0m\]\$ '
PS1='\A \[\033[1;36m\]\w\[\033[0m\]\[\033[1;35m\] $(__git_ps1 " (%s)")\[\033[0m\] ➝  '

# time currentDirectory (name of current branch)
# PS1='[\[\033[0;36m\]\A\[\033[0m\] \[\033[0;35m\]\W\[\033[0m\]\[\033[0;32m\]$(__git_ps1 " (%s)")\[\033[0m\]]\$ '

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

alias ls='ls -Ga'
alias ll='ls -lGa'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# simple ip
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
# more details
alias ip1="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
# external ip
alias ip2="curl -s http://www.showmyip.com/simple/ | awk '{print $1}'"

# grep with color, options
# usage: grep "brooke" FILEPATH
#        grepe "brooke" FILEPATH
function grepe {
  # prints whole file with matching text highlighted
  grep --color -E "$1|$" $2
}
export GREP_OPTIONS='--color=always'
export GREP_COLOR='1;7;35'

# refresh shell
alias reload='source ~/.bash_profile'
# open files
alias bashpro='atom ~/.bash_profile'
alias gitconfig='atom ~/.gitconfig'

# mysql
alias mysqlstop='sudo mysqld stop'

# create webp images from pngs
alias convertwebp='for i in *.png; do convert "$i" "${i%.png}.webp" & done'

# git aliases
alias gti='git ' # common typo
alias gtiu='git u' # common typo
alias gitu='git u' # common typo
alias gi='git ' # common typo
alias goto='git checkout '
alias gd='git diff'
alias gb='git branch '
alias gc='git commit -m '
alias gs='git status'
alias gf='git fetch --all'
alias copy-diff='git diff --name-only | pbcopy'
# Show dirty state in prompt when in Git repos
export GIT_PS1_SHOWDIRTYSTATE=1

export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
export EDITOR='atom -w'
export PATH=$PATH:~/aofl/flutter/bin

code () {
  if [[ $# = 0 ]]
  then
    open -a "Visual Studio Code"
  else
    [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
    open -a "Visual Studio Code" --args "$F"
  fi
}
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
