#!/usr/bin/env bash
# @name: yet-another-bashrc
# @spec: centos7
# @version: 2021.06.14

# Loading order of bashrc (see 'man bash')
# if login shell
#     source /etc/profile
#         export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL
#         configure  umask
#         source /etc/profile.d/*.sh
#     source ~/.bash_profile
#         source ~/.bashrc
#             SEE BELOW
#         export PATH=$PATH:$HOME/bin
# else if interactive
#     source ~/.bashrc
#         source /etc/bashrc
#             if interactive
#                 if not $PROMPT_COMMAND define $PROMPT_COMMAND
#                 configure history
#             if not login shell
#                 configure umask
#                 source /etc/profile.d/*.sh

# avoid duplicated source, and interactive shell
if [ ! -v YET_ANOTHER_BASHRC ] && [[ $- == *i* ]]; then # 
YET_ANOTHER_BASHRC=$(realpath ${BASH_SOURCE[0]}) # sourced sential
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# https://github.com/pypa/setuptools/issues/1458#issuecomment-574076414
# export PYTHONWARNINGS=ignore:::pkg_resources.py2_warn

# Do not pipe output into a pager, see `man systemctl`
export SYSTEMD_PAGER=

# bash cmd history
export HISTTIMEFORMAT="%F_%T "
[ "$(which hh 2> /dev/null)" ] \
&& PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"' \
&& eval "$(hh --show-configuration)"

# shell completions
[ "$(which kubectl 2> /dev/null)" ] && source <(kubectl completion bash)
[ "$(which aliyun 2> /dev/null)" ] && complete -C $(which aliyun) aliyun
[ "$(which helm 2> /dev/null)" ] && source <(helm completion bash)
[ "$(which yq 2> /dev/null)" ] && source <(yq shell-completion bash)

# colorful manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# cmd aliases
alias .ls='ls -alFh --time-style=long-iso --color=auto'
alias .tree='tree -fiapughDFCN --timefmt %F_%T --du --dirsfirst'
alias .grep='grep -E -n --color=auto'
alias .diff='diff -y'
alias .df='df -h'
alias .du='du -h'
alias .date='date +"%F %T %z"'
alias .tar='tar -v'
alias .free='free -h'
alias .ps='ps ux'
alias .pstree='pstree -up'
alias .fuser='fuser -v'
alias .lsof='sudo lsof'
alias .pidof='pidof -x'
alias .newgrp='newgrp -'
alias .userdel='sudo userdel -rf'
alias .grep.code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
alias .nginx.reload='sudo nginx -t && sudo systemctl reload nginx'
alias .curl.header='curl -sv -o /dev/null'
alias .curl.ip='curl -s -4 icanhazip.com'
alias .git.log='git log --graph --all --decorate --oneline'
alias .venv.clear='python3 -m venv --clear'
function .venv.activate { . $1/bin/activate; }
alias .pip3.show='pip3 --disable-pip-version-check -v show --files'
alias .pip3.list='pip3 --disable-pip-version-check list --format columns'
alias .pip3.user='pip3 --disable-pip-version-check -v install --user'
alias .ipython3='ipython3 --nosep --no-confirm-exit --no-term-title --no-automagic --colors Linux'

# for PS1

# vars
if [ -f /etc/os-release ]; then
    OS_NICKNAME=$(source /etc/os-release && echo $ID-$VERSION_ID)
elif [ "$(which lsb_release 2> /dev/null)" ]; then
    OS_NICKNAME=$(lsb_release -is)-$(lsb_release -rs)
elif [ -f /etc/system-release-cpe ]; then
    OS_NICKNAME=$(cat /etc/system-release-cpe | awk -F: '{ print $3"-"$5 }')
elif [ -f /etc/system-release ]; then
    OS_NICKNAME=$(cat /etc/system-release)
else
    OS_NICKNAME="unknown-os"
fi;

#color wrapper https://misc.flogisoft.com/bash/tip_colors_and_formatting
a='\[\e[0m\]\[\e['
b='m\]'
c=$a'0'$b
x1=$a'2;90;40'$b

# parts
PS1_LOC=$a'95;40'$b' \u'$a'1;35;40'$b'$([ "$(id -ng)" != "$(id -nu)" ] && echo ":$(id -ng)")'$x1'@'$a'3;32;40'$b"$(echo $(hostname --all-ip-addresses))"$x1'@'$a'4;34;40'$b'\H'$x1':'$a'1;33;40'$b'$PWD '$c
PS1_PMT='\n'$a'1;31'$b'\$'$c' '
PS1_RET=$a'1;97;41'$b'$(r=$?; [ $r -ne 0 ] && echo " \\$?=$r ")'$c
PS1_SHLVL=$a'1;97;43'$b'$([ 1 -ne $SHLVL ] && echo " \\$SHLVL=$SHLVL ")'$c
PS1_LOGIN=$a'1;97;45'$b'$(shopt -q login_shell; [ 0 -ne $? ] && echo " non-login ")'$c
PS1_OS=$a'3;37;100'$b" $OS_NICKNAME "$c

# python venv
VIRTUAL_ENV_DISABLE_PROMPT=1
PS1_PYVENV=$a'3;97;42'$b'$([ "$VIRTUAL_ENV" ] && echo " venv@$VIRTUAL_ENV ")'$c

# git
GIT_PMT_LIST=(
    '/usr/share/git-core/contrib/completion/git-prompt.sh'
)
for nIndex in ${!GIT_PMT_LIST[@]}; do
    if [ -f ${GIT_PMT_LIST[$nIndex]} ]; then
        GIT_PS1_SHOWDIRTYSTATE=1;
        GIT_PS1_SHOWSTASHSTATE=1;
        GIT_PS1_SHOWUNTRACKEDFILES=1;
        GIT_PS1_SHOWUPSTREAM="verbose legacy git";
        GIT_PS1_DESCRIBE_STYLE=branch;
        GIT_PS1_SHOWCOLORHINTS=1;
        source ${GIT_PMT_LIST[$nIndex]};
        PS1_GIT=$a'1;3;97;104'$b'$(__git_ps1 " %s ")'$c;
        break;
    fi
done

# all
PS1=$PS1_RET$PS1_SHLVL$PS1_LOGIN$PS1_PYVENV$PS1_GIT$PS1_OS$PS1_LOC$PS1_PMT

# clear
unset OS_NICKNAME
unset a b c x1
unset GIT_PMT_LIST PS1_RET PS1_LOC PS1_PMT PS1_SHLVL PS1_LOGIN PS1_PYVENV PS1_GIT PS1_OS

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
fi # YET_ANOTHER_BASHRC
