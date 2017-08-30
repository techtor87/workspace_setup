# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# disable ctrl-s flow lock
stty -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1=':\w$ '
else
    PS1=':\w$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1=':\w$ '
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias vi='vim'
alias cl='clear'


# Alias definitions.
alias qnx='env | grep QNX'
alias qnx_632='. ~/CI/qnx632'
alias qnx_650='. ~/CI/qnx650'
alias qde='. ~/CI/qnx650; qde'   # launch QNX Momentix IDE
alias eb='vi ~/.bashrc'
alias rb='. ~/.bashrc'
alias ev='vi ~/.vimrc'
alias et='vi ~/.tmux.conf'
alias rt='tmux source-file ~/.tmux.conf'
alias firefox='firefox &'

set -o vi           # turn on terminal vi mode
bind -m vi-insert "\C-l":clear-screen       # escape vi mode for ctrl-l to clear screen

# setxkbmap -option 'caps:swapcaps'
# xcape -e 'Caps_Lock=Escape;Control_L=Caps_Lock

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PATH=$PATH:/home/gfaulconbridge/cov-analysis-linux-8.5.0/bin

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Perforce Environment Variables
export P4PORT=ssl:getperfprod.corporate.ge.com:1666
export P4USER=GFaulconbridge_210060583
export P4CLIENT=gcf_fea_lccm
export P4PASSWD=Adel13phikos

export http_proxy=http://210060583:adel2016phikos@trans.setpac.ge.com/pac.pac/
# Function definitions.
export workspace_var="/home/gfaulconbridge/ws/08.07"
export workspace_root="/home/gfaulconbridge/ws/"

function myChanges
{
    p4 changes -u $P4USER -s pending | cut -d" " -f2 | xargs p4 describe -sS
}

function find_file
{
   if [ ! -z "$1" ]
   then
      find . -regex ".*$1.*"
   fi
}

function searchFrom
{

   if [ ! -z "$2" ]
   then
      grep -q "^.*\..*$" <<< $2
      if [ $? -eq 0 ]
      then
         DEST="/home/gfaulconbridge/search/""$2"
      else
         DEST="/home/gfaulconbridge/search/search_""$2"".txt"
      fi
   else
      DEST="/home/gfaulconbridge/search/search.txt"
   fi

   if [ ! -z "$1" ]
   then
      find . -regex ".*\.\(cc\|c\|h\|mdl\|txt\|csv\|cfg\|ini\|dat\|DAT\|db\)" | xargs grep -n "$1" | tee $DEST
   else
      echo "enter a search term"
   fi
}

function search
{
   cd  $workspace_var

   if [ ! -z "$2" ]
   then
      searchFrom $1 $2
   elif [ ! -z "$1" ]
   then
      searchFrom $1
   else
      searchFrom
   fi
}

function vi_search
{
   if [ ! -z "$1" ]
   then
      vi ~/search/$1
   else
      vi ~/search/search.txt
   fi
}

function setWorkspace
{
   if [ -z $1 ]
   then
      # echo "no workspace selected"
   # elif [ $1 == '?' ]
   # then
      echo "stream mainline shpt_rel auriz_rel miss lccm lccm632 oldCT ws"
   elif [ $1 == stream ]
   then
      export workspace_var=~/sCT/
      export P4CLIENT=gcf_streams
      export TMUX_WINDOW_TITLE=Stream_1
      export TMUX_PANE_TITLE=Stream_1
   elif [ $1 == fea_lccm ]
   then
      export workspace_var=~/gcf_fea_lccm/
      export P4CLIENT=gcf_fea_lccm
      export TMUX_WINDOW_TITLE=fea_lccm
      export TMUX_PANE_TITLE=fea_lccm
   elif [ $1 == auriz_rel ]
   then
      export workspace_var=~/gcf_shpt_auriz_rel/
      export P4CLIENT=gcf_shpt_auriz_rel
      export TMUX_WINDOW_TITLE=Auriz_Rel
      export TMUX_PANE_TITLE=Auriz_Rel
   elif [ $1 == mainline ]
   then
      export P4CLIENT=gcf_mainline
      export workspace_var=~/gcf_mainline/
      export TMUX_WINDOW_TITLE=Mainline
      export TMUX_PANE_TITLE=Mainline
   elif [ $1 == oldCT ]
   then
      export P4CLIENT=old_mainline
      export workspace_var=~/old_mainline/
      export TMUX_WINDOW_TITLE='Old Main'
      export TMUX_PANE_TITLE='Old Main'
   elif [ $1 == miss ]
   then
      export P4CLIENT=gcf_missouri
      export workspace_var=~/gcf_missouri/
      export TMUX_WINDOW_TITLE=Miss
      export TMUX_PANE_TITLE=Miss
   elif [ $1 == lccm ]
   then
      export P4CLIENT=gcf_lccm_dev
      export workspace_var=~/gcf_lccm/
      export TMUX_WINDOW_TITLE=LCCM
      export TMUX_PANE_TITLE=LCCM
   elif [ $1 == lccm632 ]
   then
      export P4CLIENT=gcf_lccm_632_dev
      export workspace_var=~/gcf_lccm_632/
      export TMUX_WINDOW_TITLE=LCCM632
      export TMUX_PANE_TITLE=LCCM632
   elif [ $1 == shpt_rel ]
   then
      export P4CLIENT=gcf_shpt_rel
      export workspace_var=~/gcf_shpt_rel/
      export TMUX_WINDOW_TITLE=SHPT_Rel
      export TMUX_PANE_TITLE=SHPT_Rel
   elif [ $1 == ws ]
   then
      export P4CLIENT=gcf_workspace
      export workspace_var=$workspace_root$2
      export TMUX_WINDOW_TITLE=$2
      export TMUX_PANE_TITLE=$2
   # else
      # export P4CLIENT=gcf_workspace
      # export workspace_var=$workspace_root$1
      # export TMUX_WINDOW_TITLE=$1
   fi

   cd $workspace_var
}

# set default workspace
setWorkspace fea_lccm

function workspace
{
    cd $workspace_var
}

function sync
{
   if [ ! -z $1 ]
   then
      if [ $1 == all ]
      then
         cd $workspace_root && p4 sync ./... && workspace
      elif [ $1 == -f ]
      then
         cd $workspace_var && p4 sync -f ./... && workspace
      else
         cd $workspace_var && p4 sync -f ./...@$1 && workspace
      fi
   else
      cd $workspace_var && p4 sync ./... && workspace
   fi
   echo
}

function ftp_megaman
{
   #rm -rf /net/raptor/net/megaman/home/gfaulconbridge/ftp_target
   #ls /net/raptor/net/megaman/home/gfaulconbridge/ftp_target
   #cp -r $workspace_var/Target /net/raptor/net/megaman/home/gfaulconbridge/ftp_target
   ssh gfaulconbridge@3.192.234.149 "rm -rf /home/gfaulconbridge/ftp_target/*; mkdir /home/gfaulconbridge/ftp_target/ppcbe"
   scp -rC $workspace_var/Target/ppcbe gfaulconbridge@3.192.234.149:/home/gfaulconbridge/ftp_target/
}

function makeout
{
   if [ ! -z $1 ]
   then
      if [ $1 == '-f' ]
      then
         tail -F $workspace_var/make.output
      else
         tail $1 $workspace_var/make.output
      fi
   else
      tail -40 $workspace_var/make.output
   fi
}


function checkout
{
   cd $workspace_var

   if [ ! -z $1 ]
   then
      if grep -q "^.*\.\(cc\|c\|h\|txt\|csv\|cfg\|ini\|dat\|DAT\|db\)$" <<< "$1"
      then
         list="$(find -name "$1")"
      else
         list="$(find -regex ".*\/$1.*\.\(cc\|c\|h\|txt\|csv\|cfg\|ini\|dat\|DAT\|db\)")"
      fi
      changelist="$(p4 changes -u gfaulconbridge -s pending | awk -v var="$P4USER@$P4CLIENT" '{if ( $6==var ){ print $2 }}' )"
      #changelist="$(p4 changes -u gfaulconbridge -s pending | awk '{ print $2, substr($0,index($0,$8))};
      select option in $list
      do
         select cl in default new $changelist
         do
            if [ $cl == "default" ]
            then
               echo "default"
               p4 edit $option
            elif [ $cl == "new" ]
            then
               echo "new"
               p4 change -o | awk '{ if ( $1 != "<enter" && $3 != "edit" ) { print $0 } }' | p4 change -i | grep -o [0-9]* | xargs -I {} p4 edit -c '{}' $option
            else
               p4 edit -c $cl $option
            fi
            break
         done
         if [ "$2" == "edit" ]
         then
           vim $option
         fi
         break
      done
   fi
}

function vi_edit
{
   cd $workspace_var
   if [ ! -z $1 ]
   then
      if grep -q "^.*\.\(cc\|c\|h\|txt\|csv\|cfg\|ini\|dat\|DAT\|db\)$" <<< "$1"
      then
         list="$(find -name "$1")"
      else
         list="$(find -regex ".*\/$1.*\.\(cc\|c\|h\|txt\|csv\|cfg\|ini\|dat\|DAT\|db\)")"
      fi

      select option in $list
      do
         vim $option
         break
      done
   fi
}
alias vie='vi_edit'

function make_only
{
   make; cd nto-x86-be.g/; find *_g | sed 's/\([a-z]*\).*/\1/' | xargs -I ntoppc-strip -o '{}' '{}'; cd ..
}

function make_all
{
   if [ ! -z $2 ]
   then
      ver=$2
   else
      ver='99.99.99'
   fi

   if [ ! -z $1 ]
   then
      if [ $1 == "new" -o $1 == "all" ]
      then
         echo "clearing workspaces"
         rm -rf ~/make_all/*
      fi
   fi

   if [ ! -d "~/make_all" ]
   then
      mkdir ~/make_all
   fi

   if [ ! -d "~/make_all/ppc" ]
   then
      mkdir ~/make_all/ppc
   fi

   if [ ! -d "~/make_all/spe" ]
   then
      mkdir ~/make_all/spe
   fi

   if [ ! -d "~/make_all/spe_ppc" ]
   then
      mkdir ~/make_all/spe_ppc
   fi

   if [ ! -d "~/make_all/spe_x86" ]
   then
      mkdir ~/make_all/spe_x86
   fi

   if [ ! -z $1 ]
   then
      curWorkspace=$(pwd)
      echo $curWorkspace
      echo "start sync"
      #chown -fR gfaulconbridge ~/make_all
      rsync -r -u --inplace --perms -q --exclude="$workspace_var/Target" $workspace_var ~/make_all/ppc
      echo "sync 1 done"
      rsync -r -u --inplace --perms -q --exclude="$workspace_var/Target" $workspace_var ~/make_all/spe
      echo "sync 2 done"
      rsync -r -u --inplace --perms -q --exclude="$workspace_var/Target" $workspace_var ~/make_all/spe_ppc
      echo "sync 3 done"
      rsync -r -u --inplace --perms -q --exclude="$workspace_var/Target" $workspace_var ~/make_all/spe_x86
      echo "sync done"
      sed -e 's/\[cpu \[.*\]/[cpu [ppc]]/' \
          -e 's/\[makegoal \[.*\]/[makegoal [$1]]/' \
          -e 's/\[app_vers \[.*\]/[app_vers [$ver]]/' \
          -e 's/\[os_vers_ppc \[.*\]/[os_vers_ppc [$ver]]/' \
          -e 's/\[makesys \[.*\]/[makesys [CCA]]/' <~/make_all/ppc/makeit.config >~/make_all/ppc/makeit.config
      cd ~/make_all/ppc; makeit632 ! &
      echo "make 1 started"
      sed -e 's/\[cpu \[.*\]/[cpu [spe]]/' \
          -e 's/\[makegoal \[.*\]/[makegoal [$1]]/' \
          -e 's/\[app_vers \[.*\]/[app_vers [$ver]]/' \
          -e 's/\[os_vers_spe \[.*\]/[os_vers_spe [$ver]]/' \
          -e 's/\[os_vers_x86 \[.*\]/[os_vers_x86 [$ver]]/' \
          -e 's/\[os_vers_ppc \[.*\]/[os_vers_ppc [$ver]]/' \
          -e 's/\[makesys \[.*\]/[makesys [SCA_CIO]]/' <~/make_all/spe/makeit.config >~/make_all/spe/makeit.config
      cd ~/make_all/spe; makeit650 ! &
      echo "make 2 started"
      sed -e 's/\[cpu \[.*\]/[cpu [ppc]]/' \
          -e 's/\[makegoal \[.*\]/[makegoal [$1]]/' \
          -e 's/\[app_vers \[.*\]/[app_vers [$ver]]/' \
          -e 's/\[os_vers_spe \[.*\]/[os_vers_spe [$ver]]/' \
          -e 's/\[os_vers_x86 \[.*\]/[os_vers_x86 [$ver]]/' \
          -e 's/\[os_vers_ppc \[.*\]/[os_vers_ppc [$ver]]/' \
          -e 's/\[makesys \[.*\]/[makesys [SCA_DISP]]/' <~/make_all/spe_ppc/makeit.config >~/make_all/spe_ppc/makeit.config
      cd ~/make_all/spe_ppc; makeit632 ! &
      echo "make 3 started"
      sed -e 's/\[cpu \[.*\]/[cpu [x86]]/' \
          -e 's/\[makegoal \[.*\]/[makegoal [$1]]/' \
          -e 's/\[app_vers \[.*\]/[app_vers [$ver]]/' \
          -e 's/\[os_vers_spe \[.*\]/[os_vers_spe [$ver]]/' \
          -e 's/\[os_vers_x86 \[.*\]/[os_vers_x86 [$ver]]/' \
          -e 's/\[os_vers_ppc \[.*\]/[os_vers_ppc [$ver]]/' \
          -e 's/\[makesys \[.*\]/[makesys [SCA_DISP]]/' <~/make_all/spe_x86/makeit.config >~/make_all/spe_x86/makeit.config
      cd ~/make_all/spe_x86; makeit632 ! &
      echo "make 4 started"
      cd $curWorkspace
   fi
}

# function P4_Opened
# {
#   p4 changes -c $P4CLIENT -l -s pending -s shelved \
#       | sed '/^$/ d' \   #remove all empty lines
#       | sed -n 's/Change \([0-9]+\)/\1/p'             #select changelist number
#       #| sed -n 's/\^.*\([0-9]{6}\).*/\1 /p'
#       #| xargs -I X p4 opened -c ...      #print all files in changelist
# }

#  &> prints error messages and stdio msgs on same stream
#  2>&1 prints error messages and stdio msgs on same stream

function update_ctag
{
   workspace
   ctags -R -o newtag . 2>/dev/null
   rm tags
   mv newtag tags
}

function encr
{

   if [ ! -z $1 ]
   then
      cd ~/config_files
      if grep -q "^.*\.\(CFG\|cfg\|txt\|TXT\)$" <<< "$1"
      then
         list="$(find -name "$1")"
      else
         list="$(find -regex ".*\/$1.*\.\(CFG\|cfg\|TXT\|txt\)")"
      fi

      select option in $list
      do
         if grep -q "^.*\.\(CFG\|cfg\)$" <<< $option
         then
            encrypt $option ${option::-4}.txt
         elif grep -q "^.*\.\(TXT\|txt\)$" <<< $option
         then
            encrypt $option ${option::-4}.CFG
         fi
         break
      done
   fi
}

function tmux_attach_py
{
    SESSION='OPTS'
    # if the session is already running, just attach to it
    tmux has-session -t $SESSION
    if [ $? -eq 0 ]
    then
        echo "Session $SESSION already exists. Attaching..."
        tmux -2 attach -t $SESSION
    else
        tmux -2 new-session -d -s $SESSION
    fi
}

function tmux_attach_cca
{
   SESSION='CCA'
   # if the session is already running, just attach to it.
   tmux has-session -t $SESSION
   if [ $? -eq 0 ]
   then
      echo "Session $SESSION already exists. Attaching..."
      tmux -2 attach -t $SESSION
   else
      tmux -2 new-session -d -s $SESSION

      # 1 - Make Status
      tmux rename-window "Status"
      tmux split-window -v
      tmux split-window -v
      tmux split-window -v
      tmux select-layout -t Status tiled
      tmux set-window-option set-titles on
      tmux set-window-option -t $SESSION:1.1 set-titles-string "Stream"
      tmux set-window-option -t $SESSION:1.2 set-titles-string "Mainline"
      tmux set-window-option -t $SESSION:1.3 set-titles-string "SHPT REL"
      tmux set-window-option -t $SESSION:1.4 set-titles-string "LCCM"
      tmux set-window-option pane-border-status top

      tmux send-keys   -t $SESSION:1.1 'setWorkspace stream; makeout -f' C-m
      tmux send-keys   -t $SESSION:1.2 'setWorkspace lccm632; makeout -f' C-m
      tmux send-keys   -t $SESSION:1.3 'setWorkspace shpt_rel; makeout -f' C-m
      tmux send-keys   -t $SESSION:1.4 'setWorkspace lccm; makeout -f' C-m

      # 2 - stream
      tmux new-window -n "CT632"
      tmux split-window -h -p 35

      tmux send-keys   -t $SESSION:2.1 'setWorkspace stream; makeout -f' C-m
      tmux send-keys   -t $SESSION:2.2 'setWorkspace stream' C-m

      # 3 - mainline
      tmux new-window -n "CT650"
      tmux split-window -h -p 35

      tmux send-keys   -t $SESSION:3.1 'setWorkspace mainline; makeout -f' C-m
      tmux send-keys   -t $SESSION:3.2 'setWorkspace mainline' C-m

      # 4 - rel_SHPT2
      tmux new-window -n "rel_SHPT2"
      tmux split-window -h -p 35

      tmux send-keys   -t $SESSION:4.1 'setWorkspace shpt_rel; makeout -f' C-m
      tmux send-keys   -t $SESSION:4.2 'setWorkspace shpt_rel' C-m

      # 5 - LCCM 632
      tmux new-window -n "LCCM632"
      tmux split-window -h -p 35

      tmux send-keys   -t $SESSION:5.1 'setWorkspace lccm632; makeout -f' C-m
      tmux send-keys   -t $SESSION:5.2 'setWorkspace lccm632' C-m

      # 6 - LCCM
      tmux new-window -n "LCCM650"
      tmux split-window -h -p 35

      tmux send-keys   -t $SESSION:6.1 'setWorkspace lccm; makeout -f' C-m
      tmux send-keys   -t $SESSION:6.2 'setWorkspace lccm' C-m

      # 7 - search
      tmux new-window -n "Search"
      tmux send-keys    -t $SESSION:7.1 'setWorkspace lccm' C-m

      #8 - BASH
      tmux new-window -n "BASH"
      tmux -2 attach -t $SESSION

   fi

   tmux select-window -t:1

}

function tmux_kill
{
    if [ $1 == 'K' ]
    then
        tmux kill-session -t 'OPTS'
        tmux kill-session -t 'CCA'
    fi
}

function workspace_py
{
   cd ~/workspace
}

function rrun
{
   workspace_py

   if [ -z "$1" ]
   then
      ruby proj_1.rb
   else
      ruby $1
   fi
}

function prun
{
   workspace_py

   if [ -z "$1" ]
   then
      python proj_1.py
   else
      python $1
   fi
}




