# -*- mode: sh -*-

# Base directory for zshell.
export ZSH_ROOT=$HOME/.local/src/zsh

# Path to your oh-my-zsh configuration.
export ZSH=$ZSH_ROOT/oh-my-zsh
export ZSHRC="$HOME/.zshrc"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme
# each time that oh-my-zsh is loaded.
export ZSH_THEME="cec"

# Set to this to use case-sensitive completion:
export CASE_SENSITIVE="true"

# Uncomment following line if you want to disable weekly auto-update
# checks.
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable autosetting terminal
# title.
#DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while
# waiting for completion.
export COMPLETION_WAITING_DOTS="true"

autoload zsh/sched

# Renaming with globbing
autoload zmv

# Watch other user login/out
watch=notme

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
HISTCONTROL=ignoreboth

setopt AUTO_CD              # cd by just entering the directory
setopt AUTO_PUSHD           # Auto pushd
setopt autocontinue         # Background processes aren't killed on exit of shell
setopt clobber              # Allow clobbering with output redirection
setopt EXTENDED_GLOB        # Extended globbing
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt MULTIOS              # Pipe to multiple outputs
setopt NO_BEEP              # Beeps are annoying
setopt NO_CORRECT           # Disable command spell check
setopt NO_FLOW_CONTROL      # If I could disable Ctrl-s completely I would!
unsetopt histverify         # Don't reload history lines

# --------------------------------------------------------------------------
# Plugins.
# --------------------------------------------------------------------------

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(    \
    ant      \
    debian   \
    extract  \
    git      \
    git-flow \
    github   \
    perl     \
    python   \
    rails    \
    ruby     \
    )

# --------------------------------------------------------------------------
# Key bindings.
# --------------------------------------------------------------------------

# Copies word from earlier in the current command line
# or previous line if it was chosen with ^[. etc
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

# Cycle between positions for ambigous completions
autoload cycle-completion-positions
zle -N cycle-completion-positions
bindkey '^[z' cycle-completion-positions

# Increment integer argument
autoload incarg
zle -N incarg
bindkey '^X+' incarg

# Write globbed files into command line
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files

# Alt+S inserts sudo at the start of a line
insert_sudo () { zle beginning-of-line; zle -U "sudo "; }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Alt+T inserts time at the start of a line
insert_time () { zle beginning-of-line; zle -U "time "; }
zle -N insert-time insert_time
bindkey "^[t" insert-time

bindkey -s '\eu' '^Ucd ..^M' # Meta-u to chdir to the parent directory
bindkey -s '\ep' '^Upopd >/dev/null^M' # If AUTO_PUSHD is set, Meta-p pops the dir stack

# --------------------------------------------------------------------------
# Auto completion.
# --------------------------------------------------------------------------

# Username completion
zstyle -d users

# Set explicitly:   zstyle ':completion:*' users mrb04 matt
# Uses /etc/passwd, minus these entries:
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
    named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys  www-data \
    avahi Debian-exim hplip list cupsys haldaemon ntpd proftpd statd

# File/directory completion, for cd command.
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'

#  and for all commands taking file arguments.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'

# Prevent offering a file (process, etc) that's already in the command line.
zstyle ':completion:*:(rm|cp|mv|kill|diff|scp):*' ignore-line yes

# Completion selection by menu for kill.
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*:*:rmdir:*' file-sort time

# CD to never select parent directory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## Use cache
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path /usr/share/zsh/cache

# Basically type '...' to get '../..' with successive .'s adding /..
function rationalise-dot {
    local MATCH
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' ]]; then
        LBUFFER+=/
        zle self-insert
        zle self-insert
    else
        zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert

source "$ZSH/oh-my-zsh.sh"

# --------------------------------------------------------------------------
# Shell environment.
# --------------------------------------------------------------------------
export EMACSRC="$HOME/.emacs.d/personal/init.el"

export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export TERM=xterm-256color

# Say how long a command took, if it took more than 30 seconds.
export REPORTTIME=30

export LOGCHECK=60

# Pagers and editors.
export VIEW=/usr/bin/elinks
export PAGER="less"
export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm \
             --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
if [[ -x $(which lesspipe.sh) ]]; then
    export LESSOPEN="| lesspipe.sh %s"
fi
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export EDITOR='vim'
export ALTERNATE_EDITOR=''
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

# Mail.
[ -d ~/mail ] && export MAILDIR=~/mail/
[ -f ~/.muttrc ] && export MUTTRC=~/.muttrc
[ -f ~/.procmailrc ] && export PROCMAILRC=~/.procmailrc
[ -f ~/.partrc ] && export PATRC=~/.config/patrc

# Development environment.
[ -f ~/.config/jhbuildrc ] && export JHBUILDRC=~/.config/jhbuildrc
[ -f ~/.config/weston.ini ] && export WESTON_INI=~/.config/weston.ini
export USE_CCACHE=1


# --------------------------------------------------------------------------
# Paths.
# --------------------------------------------------------------------------

# Accepts an array of directories and returns a colon separated path
# of all of the directories that exist, in order.  Example usage:
#
#    dirs=("/usr/local/bin" /usr/bin "/not a real path")
#    unset FOO
#    FOO=$(build_path "${dirs[@]}")
#    echo $FOO
#    # Outputs: /usr/local/bin:/usr/bin
build_path() {
    local _dir=""
    local _path=""

    for _dir in "$@"
    do
        if [ -d $_dir ]; then
            _path=$_path:$_dir
        fi
    done

    _path=${_path:1}
    echo $_path
}

export NODE_PATH=/usr/local/lib/node_modules

setopt nullglob # Globs which don't match anything expand to nothing.
pkg_config_path_dirs=( \
    /usr/local/lib/pkgconfig \
    /usr/lib/pkgconfig \
)
export PKG_CONFIG_PATH=$(build_path "${pkg_config_path_dirs[@]}")

ld_library_path_dirs=( \
    ~/phd/tools/llvm/build/lib/ \
    /opt/intel/opencl-sdk/lib64 \
    /opt/intel/intel-opencl-1.2-6.2.0.1760/opencl-sdk/lib64 \
    /usr/lib \
    /usr/lib32 \
    /usr/local/lib \
    ~/src/torch/install/lib \
)
export LD_LIBRARY_PATH=$(build_path "${ld_library_path_dirs[@]}")

path_dirs=( \
    ~/bin \
    ~/.local/bin \
    ~/.cabal/bin \
    ~/.rvm/bin \
    ~/android-sdks/platform-tools \
    ~/.gem/*/*/bin \
    ~/.gem/*/ruby/*/bin \
    ~/src/torch/install/bin/ \
    /Applications/Emacs.app/Contents/MacOS/bin \
    /Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin \
    $(brew --prefix coreutils 2>/dev/null)/libexec/gnubin \
    /usr/local/Cellar/coreutils/8.24/libexec/gnubin/ \
    /usr/lib/ccache \
    /usr/lib/postgresql/*/bin \
    /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin \
    /usr/local/bin \
    /usr/contrib/bin \
    /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64 \
    /opt/bin \
    /opt/local/bin/ \
    /opt/local/sbin/ \
    /bin \
    /usr/bin \
    /usr/bin/core_perl \
    /usr/bin/vendor_perl \
    /usr/games \
    /usr/local/mysql/bin \
    /usr/local/games \
    /usr/sbin/ \
    /usr/texbin \
    /sbin \
)
export PATH=$(build_path "${path_dirs[@]}")

unsetopt nullglob

# --------------------------------------------------------------------------
# Aliases.
# --------------------------------------------------------------------------

# Don't kill forked jobs on shell exit.
alias exit='disown &>/dev/null; exit'

# Don't foobar '/'. See chgrph(1) for --preserver-root details.
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

alias off='sudo shutdown -h now'

# Enable pretty colors.
if $(which dircolors &>/dev/null); then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" \
        || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias vdir='vdir --color=auto'
fi

# Shortcuts.
alias c='cat'
alias E='exit'
alias f='file'
alias ff='find'
alias H='head'
alias l='less'
alias ll='ls -lh'
alias m='make'
alias M='mkdir'
alias mm='./autogen.sh && ./configure'
alias p='ipython'
alias q='which'
alias R='rmdir'
alias s='subl'
alias T='tail'
alias t='touch'
alias v='vim'
alias wg='wget'

# Git goodness.
alias g='git'
alias gA='git add'
alias gC='git commit'
alias gD='git diff'
alias gL='git log'
alias gP='git push'
alias gS='git status'

# Directory stack navigation.
alias pu='pushd >/dev/null'
alias po='popd  >/dev/null'
alias st='dirs -v'

# Safe rm wrapper.
alias trash='rmtrash'

# Ping test.
alias pingg='ping -c 3 www.google.com'

# Print a table of all defined aliases.
alias alias_table="alias | sed 's/=/\t/' | sed -r 's/'"'"(.*)"'"'/\1/' | column -t -s$'\t'"

# --------------------------------------------------------------------------
# Application-specific configuration.
# --------------------------------------------------------------------------

# "git + hub = github" wrapper.
[ -x /usr/local/bin/hub ] && alias git='hub'


# --------------------------------------------------------------------------
# Distro-specific configuration.
# --------------------------------------------------------------------------

# OpenCL vendor installation.
[ -d /etc/OpenCL/vendors/ ] && export OPENCL_VENDOR_PATH=/etc/OpenCL/vendors/


# --------------------------------------------------------------------------
# Shell functions.
# --------------------------------------------------------------------------

# For performing quick calculations.
calc() {
    test -n "$1" || { echo "Usage: calc <expression>" >&2; return 1; }

    echo "$@" | bc -l
}

# Cat with ROT-13.
cat13() {
    tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]' < "$@"
}

# Plaintext cat for markdown files.
catmd() {
    test -n "$1" || { echo "Usage: catmd <files>" >&2; return 1; }

    for arg in "$@"
    do
        if [[ ${arg%.md} == "$arg" ]]; then
            echo "'$arg' does not end in .md extension" >&2
        else
            local html=${arg%.md}.html
            thor md:generate "$arg"
            html2text "$html"
            rm -f "$html"
        fi
    done
}

# Make a directory with root permissions with that belongs to user.
mkudir() {
    test -n "$1" || { echo "Usage: mkudir <directory>" >&2; return 2; }

    sudo mkdir -v "$@"
    sudo chown "$USER" "$@"
    sudo chgrp "$USER" "$@"
}

# For convenient file searching.
search() {
    test -n "$1" || { echo "Usage: search [dir] <pattern>" >&2; return 1; }
    test -n "$2" && { local d="$1"; local q="$2"; } || { local d=. local q="$1"; }
    test -d "$d" || { echo "Directory '$d' does not exist!"; return 1; }

    sudo find "$d" -iname '*'"$q"'*' 2>/dev/null | grep -v '^'"$d"'$'
    return 0
}

# Launch a webserver in the current dir.
server() {
    local port=$1

    open "http://localhost:${1}" && python -m SimpleHTTPServer $port
}

# Silence the output of a command, unless it fails. Example:
#
#     $ silent my command
silent() {
    local tmpfile="$(mktemp)"

    $@ 2>&1 > "$tmpfile" || {
        ret=$?
        cat "$tmpfile"
        rm "$tmpfile"
        exit $ret
    }
    rm "$tmpfile"
}

# Buffer standard input to a file. Useful for redirecting output of a
# pipe chain to the same input file. Example:
#
#     $ grep -v 'a' foo | sponge foo
sponge() {
    if [ -z "$1" ]; then
        echo "$(basename $0):$LINENO sponge():  No file name given!"
        exit 1
    fi

    # Create a temporary file.
    local tmpfile="$(mktemp)"
    # Redirect all stdin in to the temporary file.
    cat > "$tmpfile"
    # Replace the destintation file with the temporary file.
    mv "$tmpfile" "$1"
}

# Super simple and super strong encryption.
cry() {
    test -n "$1" || { echo "Usage: cry <file ...>" >&2; return 1; }

    for f in "$@"; do
        if [[ ${f##*.} == "cry" ]]; then
            scrypt dec "$f" > "${f%.cry}"
            if (( $? )); then
                echo "Decryption failed on '$f'" >&2
                return 1
            fi
        else
            scrypt enc "$f" > "$f".cry
            if (( $? )); then
                echo "Encryption failed on '$f'" >&2
                return 1
            fi
        fi

        rm -f "$f"
    done
}

# TODO list tracking.
todo() {
    local dir="."
    test -n "$1" && dir="$1"

    for f in $(find "$dir" -type f 2>/dev/null | grep -v .git); do
        grep -iHn 'TODO\|FIXME' "$f" 2>/dev/null
    done

    return 0
}

# Easy-open.
if [[ "$(uname -s)" == "Darwin" ]]; then
    alias xo='open'
else
    xo() {
        xdg-open "$@" &>/dev/null
    }
fi

# --------------------------------------------------------------------------
# External files.
# --------------------------------------------------------------------------

setopt nullglob

# Load bash profiles from /etc/profile.d
if test -d /etc/profile.d/; then
    for profile in /etc/profile.d/*.sh; do
        test -r "$profile" && . "$profile"
    done
    unset profile
fi

# Custom zsh scripts that are placed in the local/ directory will automatically
# be sourced at launch.
if test -d "$ZSH_ROOT/local"; then
    for script in $ZSH_ROOT/local/*.zsh; do
        test -r "$script" && . "$script"
    done
    unset script
fi

# If rbenv is installed, inject shims into PATH. See:
#
#    https://github.com/sstephenson/rbenv#how-it-works
if [[ -x $(which rbenv) ]]; then
    eval "$(rbenv init -)"
fi

# If torch is present, activate it.
if test -f "~/torch/install/bin/torch-activate"; then
    . ~/torch/install/bin/torch-activate
fi

unsetopt nullglob
