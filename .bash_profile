# COLORS 
export PS1="\[\e[36;1m\]\s\v \[\e[32;1m\]{\W}$ \[\e[0m\]"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad


# Directory Shortcuts
#--Space Weather
alias sw='cd ~/Research/SpaceWeather/'
# Data Directory
alias data='cd ~/DATA/'
#--Personal Website 
alias ku='cd ~/Research/Websites/Personal/'
#--TL Website
alias tl='cd ~/Google\ Drive/Research/Websites/TL'
# Dissertation directory
alias dis='cd ~/Research/SpaceWeather/0_Dissertation/'
# iTunes Music Directory
alias music='cd ~/Music/iTunes/iTunes\ Media/Music/'
# IDL: TL Code
alias tlidl='cd /Applications/exelis/idl82/lib/research/mine/TL_Suite/'
# IDL: Research Code
alias myidl='cd /Applications/exelis/idl82/lib/research/mine/'
# WWE Research
alias wwe='cd ~/Research/DataSci/WWE/'
# Udacity Courses
alias udacity='cd ~/Research/Courses/Udacity/'
# BASH: TL Research
alias tlbash='cd ~/bin/bash/Research/'
# GDL
alias mygdl='cd /usr/local/Cellar/gnudatalanguage/'
# Octave Command Line
alias octavecl='octave --no-gui'

#cmd shortcuts
# always use mvim
# alias vim='mvim'
alias ls='ls -G'; alias LS='ls'
alias la='ls -a'
alias ll='ls -lh'
alias print='echo'
# list just directories
alias lsd='ls -d */'
alias lsad='ls -d .*/; ls -d */'
alias ldir='ls -d */'
# Getting Around
alias ..='cd ..'
alias ..2='cd ../../'
alias ..3='cd ../../../'
alias ..4='cd ../../../../'
# change mode....
alias cx='chmod u+x'
# Abridged History Command
alias h='history'
# History Search
alias hg='cat ~/.bash_history | grep'
# Verbose Copy
alias cp='cp -v'
# Safer Removal
# alias rm='rm -i'
# Folder Space
alias ds='du -hs'
# Free Disk Space (human-readable)
alias df='df -h'
# MKDIR PRIME: Automatically Create Necessary Parent Folders
alias mkdir='mkdir -p'
# Number of files, dirs, etc in '.'
alias nls="ls | wc -l"
alias nla="ls -a | wc -l"
alias nld="ls -d */ | wc -l"
# Find-Grep "From here, down"
# -- will take very long running in ~ or / dirs
alias fghd="find -f . * | grep"
# Time Stuff
DATE=`date +%F`
DateTime=`date +%F-%H%M`
# Assuming ASPELL has been BrewInstalled: spell check a document
alias spch='aspell check'
# TL Website Stuff
alias ftl='ftp agerrard@terrestrial-lab.org'
alias sx='stat -x'
alias path="printf ${PATH//:/'\n'}'\n'"
# Open RStudio
alias rst='open /Applications/RStudio.app'
# actmon -- alias for 'open /Applications/Utilities/Activity\ Monitor.app'
alias actmon='open /Applications/Utilities/Activity\ Monitor.app'
# console -- alias for ' open /Applications/Utilities/Console.app'
alias console='open /Applications/Utilities/Console.app'
# sysinf -- alias for 'open /Applications/Utilities/System\ Information.app'
alias sysinf='open /Applications/Utilities/System\ Information.app'
# dugui-- alias for 'open /Applications/Utilities/Disk\ Utility.app'
alias dugui='open /Applications/Utilities/Disk\ Utility.app'
# chrome -- open Chrome
alias chrome='open /Applications/Google\ Chrome.app'
# Power Point --- open
alias powerpoint='open /Applications/Microsoft\ Office\ 2011/Microsoft\ PowerPoint.app/'
dog () { awk '{print NR,$0}' $* ; }
lsg() { if ((${#} == 1)); then ls | grep "$1"; else ls $1 | grep $2; fi; }


# Add bash scripts
myBash=$(echo /Users/Kurban/bin/bash{,/BashHelp,/LaTeX,/KuSite,/AGO,/SwPrez,/IDL} | sed 's/ /:/g')
add2path=$myBash
homeBrewSBin="/usr/local/sbin:"

#PATH=/usr/local/bin:/usr/texbin:$PATH:${add2path}
# Jan 29, 2014: I downloaded TeXLive2013 so I can update my LaTeX packages and
# get some new packages (e.g., fancyhd). Since I didn't uninstall all of MacTeX
# and reinstall the latest MacTex2013, /usr/texbin still points to all TexLive2011
# stuff. To circumvent this for now, I just have to add to my path a direct route
# to the 2013 stuff and take the 2011 route out.
#PATH=/usr/local/bin:/usr/local/texlive/2013:$PATH:${add2path}
PATH=${homeBrewSBin}/usr/local/bin:/usr/local/texlive/2013/bin/x86_64-darwin:$PATH:${add2path}
#export PATH
export PATH=~/anaconda3/bin:"$PATH"

# GIVE COMMAND LINE VI-LIKE FEATURES
set -o vi


# GIT ALIASES
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


# virtualenvwrapper stuff
WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# SOURCE IDL: THIS WILL SET-UP THE "IDL" COMMAND-LINE COMMANDS
source /Applications/exelis/idl82/bin/idl_setup.bash
# IDL START-UP FILE
IDL_STARTUP=~/.idl_startup.pro
export IDL_STARTUP
# CUSTOM IDL PATHS
# ...need to figure out how to get IDL to recursively search subdirs of a custom
IDL_PATH='~/bin/IDL/TL_Suite:<IDL_DEFAULT>'
export IDL_PATH
# IDL DLM PATHS
IDL_DLM_PATH='~/bin/IDL/DLM:<IDL_DEFAULT>'
export IDL_DLM_PATH
# Add IDL to search path
export PATH=$PATH:/Application/exelis/idl82/bin
# The idl alias doesn't get passed into bash scripts... But functions do.
idlq () { "/Applications/exelis/idl82/bin/idl" -quiet; }
alias IDL='idl'
# Environment Var for updated CDF Reader
# See: http://cdf.gsfc.nasa.gov/html/cdf_patch_for_idl.html
export CDF_LEAPSECONDSTABLE='/Applications/exelis/idl82/lib/research/cdf/CDFLeapSeconds.txt'

# r --vanilla: opens/closes r without a fingerprint: --no-save, --no-restore, --no-site-file, --no-init-file and --no-environ
# r --slave: makes R run as quietly as possible
rvs () { r --vanilla --slave ; }
rvs2 () { rvs | sed 's/\[.*\]  //' ; }

# SQLite3:  The native version is old, but still ''sqlite3'' at the command line
#   -- to use the the much newer, brew-installed sqlite3, type ''sqlite''

###############################################
#######   Calculators   #######################
#rc () { r --slave -e $* | awk '{first=$1; $1=""; print $0}' ;}
#argh () { r --slave -e $* ; }
#pc () { python -c "print $1"; }

###############################################
#######  Helpful Research Functions  ##########
#findproj () { ext=""; if [ -z "$1" ]; then echo "Error: Enter Project Name"; return; fi; found=`find ~/Research$ext -path "*$1" -type d | head -1` ; echo "$found"; } # Last part there ensures only one entry is returned; no issues w/ this so far.
# It was important to do this so that cdproj worked properly; that said, can implement in cdproj
# instead if you want findproj to list more than one entry... But that could be another entry, say, lsproj.

#cdproj () { proj=`findproj $1`; if [ ${proj:0:6} == "Error:" ]; then echo $proj; else echo "Leaving $PWD"; echo "Entering $proj"; cd $proj; fi; }

#lsproj () { proj=`findproj $1`; if [ ${proj:0:6} == "Error:" ]; then echo $proj; else echo "Current directory: $PWD"; echo "Listed directory: $proj"; ls $proj; fi; }

#moreproj () { 
#    do_cat=0
#    if [ $1 == "-c" ]; then do_cat=1; shift; fi
#    proj=`findproj $1`; 
#    if [ ${proj:0:6} == "Error:" ]; then 
#      echo $proj; 
#    else 
#      echo "Listed directory: $proj"; 
#      ls $proj; printf "\nSelect file: \n"; 
#      read; 
#      printf "\n\n\n"
#      if ((do_cat==1)); then
#        cat ${proj}/$REPLY; printf "\n\n\n";
#      else
#        more ${proj}/$REPLY; 
#      fi;
#    fi; 
#    printf "\n\n\n";
#}

#addproj () { 
#    if [ "$1" == "--help" ]; then echo "Add the code directory of any project under ~/Research.";
#    echo "To see if project exists, use findproj."; exit 1; fi; 
#    proj=$1; 
#    if [ -z "$1" ]; then printf "Error: Enter Project Name\n-- For more info, type: addproj --help\n"; 
#    else # In case I include the /code part sometimes and sometimes not, make consistent
#    proj=`find ~/Research -path "*${proj%/code}" -type d`; 
#    fi
#  proj="${proj}/code"
#  PATH=${PATH}:$proj
#
#  printf "Added to PATH: \n$proj\n"
#} #endFcn



# The next line updates PATH for the Google Cloud SDK.
source '/Users/Kurban/Research/Websites/HooknUp/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/Kurban/Research/Websites/HooknUp/google-cloud-sdk/completion.bash.inc'

# Put App Engine in Path
export PATH=$PATH:/Users/Kurban/Research/Websites/HooknUp/google_appengine
VIRTUALENVWRAPPER_PYTHON=/Users/Kurban/anaconda3/bin/python 

# Bash Completion
# -- if you don't have it, brew install bash-completion
# -- for brew completions, then: brew tap homebrew/completions
if [ -f $(brew --prefix)/etc/bash_completion ]; then 
	. $(brew --prefix)/etc/bash_completion
fi

# Tmux
export TERM="screen-256color"
alias tmux='tmux -2'

# Python -> iPython
#  -- will this fuck anything up?
#  -- yes


