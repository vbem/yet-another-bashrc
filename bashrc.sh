__CLR_BEG='\[\e['
__CLR_MID='m\]'
__CLR_END=$__CLR_BEG$__CLR_MID
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then \
    source /usr/share/git-core/contrib/completion/git-prompt.sh; \
    GIT_PS1_SHOWDIRTYSTATE=1; GIT_PS1_SHOWSTASHSTATE=1; GIT_PS1_SHOWUNTRACKEDFILES=1; GIT_PS1_SHOWUPSTREAM="verbose legacy git"; GIT_PS1_DESCRIBE_STYLE=branch; GIT_PS1_SHOWCOLORHINTS=1; \
    __PS1_GIT=$__CLR_BEG'43;1'$__CLR_MID'$(__git_ps1 "(%s)")'$__CLR_END; \
fi
#__PS1_RET=$__CLR_BEG'41;1'$__CLR_MID'(\\$?=$?)'$__CLR_END
__PS1_RET=$__CLR_BEG'41;1'$__CLR_MID'$(r=$?; if [ $r -ne 0 ]; then echo "(\\$?=$r)";fi)'$__CLR_END
__PS1_LOGIN=$__CLR_BEG'45;1'$__CLR_MID'$(shopt -q login_shell; if [ 0 -ne $? ]; then echo "(non-login-shell)"; fi)'$__CLR_END
__PS1_GRP=$__CLR_BEG'44;1'$__CLR_MID'$(if [ "$(id -ng)" != "$(id -nu)" ]; then echo "(newgrp:$(id -ng))"; fi)'$__CLR_END
__PS1_LOC=$__CLR_BEG'42;1'$__CLR_MID$__CLR_BEG'33'$__CLR_MID'\u'$__CLR_BEG'37'$__CLR_MID'@'$__CLR_BEG'36'$__CLR_MID'\H'$__CLR_BEG'37'$__CLR_MID':'$__CLR_BEG'35'$__CLR_MID'$PWD'$__CLR_END
__PS1_PRT='\n'$__CLR_BEG'1;31'$__CLR_MID'\$'$__CLR_END' '
PS1=$__PS1_RET$__PS1_LOGIN$__PS1_GRP$__PS1_GIT$__PS1_LOC$__PS1_PRT
unset __CLR_BEG __CLR_MID __CLR_END __PS1_GIT __PS1_RET __PS1_LOGIN __PS1_GRP __PS1_LOC __PS1_PRT

alias .ls='ls -alFh --time-style=long-iso --color=auto'
alias .tree='tree -fiapughDFC --timefmt %F_%T --du --dirsfirst'
alias .grep='grep -E -n --color=auto'
alias .diff='diff -y'
alias .df='df -h'
alias .du='du -h'
alias .date='date +"%F %T"'
alias .man="env \
LESS_TERMCAP_mb=$'\E[01;31m' \
LESS_TERMCAP_md=$'\E[01;31m' \
LESS_TERMCAP_me=$'\E[0m' \
LESS_TERMCAP_se=$'\E[0m' \
LESS_TERMCAP_so=$'\E[01;44;33m' \
LESS_TERMCAP_ue=$'\E[0m' \
LESS_TERMCAP_us=$'\E[01;32m' \
man"
alias .tar='tar -v'
alias .free='free -h'
alias .ps='ps ux'
alias .pstree='pstree -up'
alias .fuser='fuser -v'
alias .lsof='sudo lsof'
alias .pidof='pidof -x'
alias .ss='sudo ss -nptua'
alias .systemctl='sudo systemctl --no-pager'
alias .journalctl='sudo journalctl'
alias .newgrp='newgrp -'
alias .userdel='sudo userdel -rf'
alias .date-md5='date +"%F %T %N" | md5sum '
alias .grep-code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
alias .nginx-reload='sudo nginx -t && sudo systemctl reload nginx'
alias .curl-header='curl -sv -o /dev/null'
alias .bench-teddysun='curl https://raw.githubusercontent.com/teddysun/across/master/bench.sh | bash'
alias .bench-freevps='curl https://freevps.us/downloads/bench.sh | bash'
alias .pub-ip='curl -s -4 icanhazip.com'
alias .git-log='git log --graph --all --decorate --oneline'
