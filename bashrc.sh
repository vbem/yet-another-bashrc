# aliases
alias .ls='ls -alFh --time-style=long-iso --color=auto'
alias .tree='tree -fiapughDFC --timefmt %F_%T --du --dirsfirst'
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
alias .ss='sudo ss -nptua'
alias .systemctl='sudo systemctl --no-pager'
alias .journalctl='sudo journalctl'
alias .newgrp='newgrp -'
alias .userdel='sudo userdel -rf'
alias .grep.code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
alias .nginx.reload='sudo nginx -t && sudo systemctl reload nginx'
alias .curl.header='curl -sv -o /dev/null'
alias .curl.bench.teddysun='curl https://raw.githubusercontent.com/teddysun/across/master/bench.sh | bash'
alias .curl.bench.freevps='curl https://freevps.us/downloads/bench.sh | bash'
alias .curl.ip='curl -s -4 icanhazip.com'
alias .git.log='git log --graph --all --decorate --oneline'
alias .python.unittest='python -m unittest -cvb'
alias .python.unittest.discover='python -m unittest discover -cvb'
alias .pip.install='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'
alias .npm.taobao='npm --registry https://registry.npm.taobao.org'

# aws-cli
export AWS_DEFAULT_REGION='cn-north-1'

# pyvenv & virtualenv
function .source.activate {
    source $1/bin/activate
}

# pip bash completion
source <(pip completion --bash > /dev/null/ 2>&1)

# colorful manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# PS1
#color wrapper
CLR_BEG='\[\e['
CLR_MID='m\]'
CLR_END=$CLR_BEG'0'$CLR_MID
# most fixed
PS1_RET=$CLR_BEG'41;1'$CLR_MID'$(r=$?; if [ $r -ne 0 ]; then echo " \\$?=$r ";fi)'$CLR_END
PS1_LOC=$CLR_BEG'42;1;33'$CLR_MID' \u'$CLR_BEG'37'$CLR_MID'@'$CLR_BEG'36'$CLR_MID'\H'$CLR_BEG'37'$CLR_MID':'$CLR_BEG'35'$CLR_MID'$PWD '$CLR_END
PS1_PMT='\n'$CLR_BEG'1;31'$CLR_MID'\$'$CLR_END' '
# system environments
PS1_SHLVL=$CLR_BEG'43;1'$CLR_MID'$(if [ 1 -ne $SHLVL ]; then echo " \\$SHLVL=$SHLVL "; fi)'$CLR_END
PS1_LOGIN=$CLR_BEG'43;1'$CLR_MID'$(shopt -q login_shell; if [ 0 -ne $? ]; then echo " non-login-shell "; fi)'$CLR_END
PS1_GRP=$CLR_BEG'43;1'$CLR_MID'$(if [ "$(id -ng)" != "$(id -nu)" ]; then echo " effective-group:$(id -ng) "; fi)'$CLR_END
# development environments
VIRTUAL_ENV_DISABLE_PROMPT=1
PS1_PYVENV=$CLR_BEG'44'$CLR_MID'$(if [ -n "$VIRTUAL_ENV" ]; then echo " PyEnv:$VIRTUAL_ENV ";fi)'$CLR_END
GIT_PMT_LIST=(
    '/usr/share/git-core/contrib/completion/git-prompt.sh'
)
for nIndex in ${!GIT_PMT_LIST[@]}; do \
    if [ -f ${GIT_PMT_LIST[$nIndex]} ]; then \
        GIT_PS1_SHOWDIRTYSTATE=1 \
        GIT_PS1_SHOWSTASHSTATE=1 \
        GIT_PS1_SHOWUNTRACKEDFILES=1 \
        GIT_PS1_SHOWUPSTREAM="verbose legacy git" \
        GIT_PS1_DESCRIBE_STYLE=branch \
        GIT_PS1_SHOWCOLORHINTS=1 \
        source ${GIT_PMT_LIST[$nIndex]}; \
        PS1_GIT=$CLR_BEG'45'$CLR_MID'$(__git_ps1 " %s ")'$CLR_END; \
        break; \
    fi \
done
# integration
PS1=$PS1_RET$PS1_SHLVL$PS1_LOGIN$PS1_GRP$PS1_PYVENV$PS1_GIT$PS1_LOC$PS1_PMT
unset GIT_PMT_LIST CLR_BEG CLR_MID CLR_END PS1_RET PS1_LOC PS1_PMT PS1_SHLVL PS1_LOGIN PS1_GRP PS1_PYVENV PS1_GIT
