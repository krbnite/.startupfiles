#===============================================
# COLORS 
#===============================================
export PS1="\[\e[31;1m\]\s\v \[\e[35;1m\]{\W}$ \[\e[0m\]"
export CLICOLOR=1

#changed 2017-07-14 (trying to get ls to have more solarized colors)
#export LSCOLORS=ExFxBxDxCxegedabagacad
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx  # Nice!
# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'   # Nice!


#===============================================
# GIVE COMMAND LINE VI-LIKE FEATURES
#===============================================
set -o vi

#===============================================
# Update Start-Up Files
#===============================================
.update() {
  cp `ls -lrtF -d -1 .startupfiles/{,.*} | grep "[a-z]$"` ~
}

#===============================================
# Directory Shortcuts
#===============================================
alias chrome='open /Applications/Google\ Chrome.app'
alias rstudio='open /Applications/RStudio.app'
alias psql0='brew services start postgres'
alias psqlf='brew services stop postgres'

#------------------------
# Work Computer
#------------------------
if [ `hostname` = 'MAC-MBP161511.local' ]; then
  source ~/.workaliases;
  alias ~~='cd /Volumes/kurban'; 
  alias pgadmin='open /Applications/pgAdmin\ 4.app'
fi
#------------------------
# Home Computer
#------------------------
if [ `hostname` = 'Cephin-Herbin.local' ]; then
  source .homealiases;
  alias ~~='cd ~'; 
  # VirtualEnv Stuff
  VIRTUALENVWRAPPER_PYTHON=/Users/Kurban/anaconda3/bin/python 
  export PATH=~/anaconda3/bin:"$PATH"
  WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/bin/virtualenvwrapper.sh
fi

export PATH=~/anaconda3/bin:"$PATH"

#===============================================
# Cmd shortcuts
#===============================================
alias ls='ls -G'                       # Colored Output
alias la='ls -a'                       # List Everything!
alias ll='ls -lh'                      # Detailed List, Human-Readable
alias lsd='ls -d */'                   # List Unhidden Directories
alias ldir='ls -d */'                  #   --same
alias lsad='ls -d .*/; ls -d */'       # List All Directories
alias nls="ls | wc -l"                 # Number of ls items 
alias nla="ls -a | wc -l"              # Number of la items
alias nld="ls -d */ | wc -l"           # Number of unhidden directories
lsg() {                                # ls grep
  if ((${#} == 1)); then 
    ls | grep "$1"; 
  else ls $1 | grep $2; 
  fi; }
dog () { awk '{print NR,$0}' $* ; }    # cat w/ line numbers
alias print='echo'                     # Print Statement!
alias ..='cd ..'                       # Take a step back
alias ..2='cd ../../'                  # Take two steps back
alias cx='chmod u+x'                   # Change Mode
alias h='history'                      # Abridged History Command
alias hg='cat ~/.bash_history | grep'  # History Search
alias cp='cp -v'                       # Verbose Copy
# alias rm='rm -i'                     # Safer Removal
alias ds='du -hs'                      # Folder Space
alias df='df -h'                       # Free Disk Space 
alias mkdir='mkdir -p'                 # Mkdir makes path where necessary
alias ymd=`date +%F`                   # Date: YYYY-MM-DD
alias datetime=`date +%F\ %H:%M:%S`    # Date: YYYY-MM-DD HH:MM:SS
alias spch='aspell check'              # spell check (aspell must be installed)



#===============================================
# System Health
#===============================================
alias actmon='open /Applications/Utilities/Activity\ Monitor.app'    # Activity Monitor
alias console='open /Applications/Utilities/Console.app'             # Console
alias sysinf='open /Applications/Utilities/System\ Information.app'  # System Info
alias dugui='open /Applications/Utilities/Disk\ Utility.app'         # Disk Utility
#alias fghd="find -f . * | grep"        # Find-Grep "From here, down"
                                       # -- use w caution in ~ or / 

homeBrewSBin="/usr/local/sbin:"




#===============================================
# GIT ALIASES
#===============================================
alias gstat='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias got='git '
alias get='git '




#===============================================
# Quick R Batch Jobs
#===============================================
# r --vanilla: opens/closes r without a fingerprint;
#   Vanilla implies:
#     --no-save, --no-restore, --no-site-file, 
#     --no-init-file, --no-environ
# r --slave: makes R run as quietly as possible
rvs () { r --vanilla --slave ; }
rvs2 () { rvs | sed 's/\[.*\]  //' ; }


#===============================================
#  Calculators  
#===============================================
#rc () { r --slave -e $* | awk '{first=$1; $1=""; print $0}' ;}
#argh () { r --slave -e $* ; }
pc () { python -c "print $1"; }


#===============================================
# Bash Completion
#===============================================
# -- if you don't have it, brew install bash-completion
# -- for brew completions, then: brew tap homebrew/completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#===============================================
# Tmux
#===============================================
export TERM="screen-256color"
alias tmux='tmux -2'


