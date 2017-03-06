eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Include git branch in prompt
PS1='[\t \W$(__git_ps1 " (%s)")]\$ '

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#alias ls='ls -GFh'
alias ls='ls -G'
alias ll='ls -lGa'

alias goto='git checkout '
alias gd='git diff'
alias gb='git branch '
alias gc='git commit -m '
alias gs='git status'
alias gf='git fetch --all'
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