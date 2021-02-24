#!/usr/bin/env bash
# @spec: amazonlinux
# @version: 2020.4.22

if [ ! -v YET_ANOTHER_BASHRC ]; then # avoid duplicated source
YET_ANOTHER_BASHRC=$(realpath ${BASH_SOURCE[0]}) # sourced sential
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# see `man systemctl`
export SYSTEMD_PAGER=

# https://github.com/pypa/setuptools/issues/1458#issuecomment-574076414
export PYTHONWARNINGS=ignore:::pkg_resources.py2_warn

# set aws region env if not set
if [ ! -v AWS_DEFAULT_REGION ]; then
    export AWS_DEFAULT_REGION=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
fi

# bash cmd history
export HISTTIMEFORMAT="%F_%T "
[ "$(which hh 2> /dev/null)" ] && eval "$(hh --show-configuration)"

if [[ $- == *i* ]]; then # interactive shell
    
    # kubectl installed
    if [ "$(which kubectl 2> /dev/null)" ]; then
        source <(kubectl completion bash)
    fi

    # colorful manpage
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'

    # EC2 metadata aliases
    alias .ec2.document='curl -s 169.254.169.254/latest/dynamic/instance-identity/document'
    alias .ec2.region="curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//'"
    alias .ec2.az='curl -s 169.254.169.254/latest/meta-data/placement/availability-zone'
    alias .ec2.role='curl -s 169.254.169.254/latest/meta-data/iam/security-credentials/'
    alias .ec2.id='curl -s 169.254.169.254/latest/meta-data/instance-id'
    alias .ec2.type='curl -s 169.254.169.254/latest/meta-data/instance-type'
    alias .ec2.localipv4='curl -s 169.254.169.254/latest/meta-data/local-ipv4'
    alias .ec2.publicipv4='curl -s 169.254.169.254/latest/meta-data/public-ipv4'
    alias .ec2.sg='curl -s 169.254.169.254/latest/meta-data/security-groups'
    alias .ec2.amiid='curl -s 169.254.169.254/latest/meta-data/ami-id'
    alias .ec2.userdata='curl -s 169.254.169.254/latest/user-data'
    alias .ec2.tags='aws ec2 --region $(curl -s 169.254.169.254/latest/dynamic/instance-identity/document|jq -Mrc .region) describe-tags --filters Name=resource-id,Values=$(curl -s 169.254.169.254/latest/meta-data/instance-id) | jq -Mrc "[.Tags[]|{(.Key):.Value}]|add"'

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

    # for PS1

    # vars
    EC2_REGION=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
    EC2_ID=$(curl -s 169.254.169.254/latest/meta-data/instance-id)
    EC2_NICKNAME=$EC2_ID # init value

    if [ "$(which aws 2> /dev/null)" ] && [ "$(which jq 2> /dev/null)" ]; then
        EC2_TAGS_ORI=$(aws ec2 --region $EC2_REGION describe-tags --filters Name=resource-id,Values=$EC2_ID 2> /dev/null)
        if [ "$EC2_TAGS_ORI" ]; then
            EC2_TAG_NAME=$(echo $EC2_TAGS_ORI |  jq -Mrc "[.Tags[]|{(.Key):.Value}]|add|.Name")
            [ "null" != "$EC2_TAG_NAME" ] && EC2_NICKNAME=$EC2_TAG_NAME
        fi
    fi

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
    PS1_LOC=$a'95;40'$b' \u'$a'1;35;40'$b'$([ "$(id -ng)" != "$(id -nu)" ] && echo ":$(id -ng)")'$x1'@'$a'3;32;40'$b"$(echo $(hostname --all-ip-addresses))"$x1'@'$a'4;34;40'$b"$EC2_NICKNAME"$x1':'$a'1;33;40'$b'$PWD '$c
    PS1_PMT='\n'$a'1;31'$b'\$'$c' '
    PS1_RET=$a'1;97;41'$b'$(r=$?; [ $r -ne 0 ] && echo " \\$?=$r ")'$c
    PS1_SHLVL=$a'1;97;43'$b'$([ 1 -ne $SHLVL ] && echo " \\$SHLVL=$SHLVL ")'$c
    PS1_LOGIN=$a'1;97;45'$b'$(shopt -q login_shell; [ 0 -ne $? ] && echo " non-login ")'$c
    PS1_OS=$a'3;37;100'$b" $OS_NICKNAME "$c

    # python venv
    VIRTUAL_ENV_DISABLE_PROMPT=1
    PS1_PYVENV=$a'3;97;42'$b'$([ "$VIRTUAL_ENV" ] && echo " PyEnv:$VIRTUAL_ENV ")'$c
    
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
    unset EC2_ID EC2_REGION EC2_TAGS_ORI EC2_TAG_NAME EC2_NICKNAME OS_NICKNAME
    unset a b c x1
    unset GIT_PMT_LIST PS1_RET PS1_LOC PS1_PMT PS1_SHLVL PS1_LOGIN PS1_PYVENV PS1_GIT PS1_OS

fi # interactive shell

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
fi # avoid duplicated source
