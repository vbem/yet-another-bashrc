PS1='\[\e[1;42m \\$?=$? $(shopt -q login_shell; if [ 0 -ne $? ]; then echo "NON-LOGIN "; fi)\[\e[m\]'\
'\[\e[1;35m\]\u\[\e[m\]:\[\e[34m\]$(id -ng)\[\e[m\]@\[\e[33m\]\H\[\e[m\]:\[\e[1;36m\]$PWD\[\e[m\]'\
'\n\[\e[1;31m\]\$\[\e[m\] '
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then source /usr/share/git-core/contrib/completion/git-prompt.sh; GIT_PS1_SHOWDIRTYSTATE=1; PS1='$(__git_ps1 "[%s]")'$PS1; fi
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
alias .git-log='git log --graph --all --decorate --abbrev-commit --date=iso'
