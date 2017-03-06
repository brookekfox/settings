eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Include git branch in prompt
PS1='[\t \W$(__git_ps1 " (%s)")]\$ '

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#alias ls='ls -GFh'
alias ls='ls -Ga'
alias ll='ls -lGa'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# up 'n' folders
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# simple ip
alias ip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\ -f2'
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

# git aliases
alias goto='git checkout '
alias gd='git diff'
alias gb='git branch '
alias gc='git commit -m '
alias gs='git status'
alias gf='git fetch --all'
# Show dirty state in prompt when in Git repos
export GIT_PS1_SHOWDIRTYSTATE=1

alias build='sh build.sh'

export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
export EDITOR='atom -w'

code () {
  if [[ $# = 0 ]]
  then
    open -a "Visual Studio Code"
  else
    [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
    open -a "Visual Studio Code" --args "$F"
  fi
}
