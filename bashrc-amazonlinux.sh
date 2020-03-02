#!/usr/bin/env bash
# @version: 2020.3.2

if [ ! -v YET_ANOTHER_BASHRC ]; then # avoid duplicated source
YET_ANOTHER_BASHRC=$(realpath ${BASH_SOURCE[0]}) # sourced sential
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# set aws region env if not set
if [ ! -v AWS_DEFAULT_REGION ]; then
    export AWS_DEFAULT_REGION=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
fi

# bash cmd history
export HISTTIMEFORMAT="%F_%T "
[ -n "$(which hh 2> /dev/null)" ] && eval "$(hh --show-configuration)"

if [[ $- == *i* ]]; then # interactive shell

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
    alias .newgrp='newgrp -'
    alias .userdel='sudo userdel -rf'
    alias .grep.code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
    alias .nginx.reload='sudo nginx -t && sudo systemctl reload nginx'
    alias .curl.header='curl -sv -o /dev/null'
    alias .curl.ip='curl -s -4 icanhazip.com'
    alias .git.log='git log --graph --all --decorate --oneline'

    # PS1

    # OS nickname
    if [ -f /etc/os-release ]; then
        OS_NICKNAME=$(source /etc/os-release && echo $ID-$VERSION_ID)
    elif [ -n "$(which lsb_release 2> /dev/null)" ]; then
        OS_NICKNAME=$(lsb_release -is)-$(lsb_release -rs)
    elif [ -f /etc/system-release-cpe ]; then
        OS_NICKNAME=$(cat /etc/system-release-cpe | awk -F: '{ print $3"-"$5 }')
    elif [ -f /etc/system-release ]; then
        OS_NICKNAME=$(cat /etc/system-release)
    else
        OS_NICKNAME="unknown-os"
    fi;

    # EC2 nickname
    EC2_ID=$(curl -s 169.254.169.254/latest/meta-data/instance-id)
    EC2_REGION=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
    EC2_TAGS_ORI=$(aws ec2 --region $EC2_REGION describe-tags --filters Name=resource-id,Values=$EC2_ID 2> /dev/null)
    [ -z "$EC2_TAGS_ORI" ] && EC2_TAG_NAME=null || EC2_TAG_NAME=$(echo $EC2_TAGS_ORI |  jq -Mrc "[.Tags[]|{(.Key):.Value}]|add|.Name")
    [ "null" == "$EC2_TAG_NAME" ] && EC2_NICKNAME=$EC2_ID || EC2_NICKNAME=$EC2_TAG_NAME

    #color wrapper
    CLR_BEG='\[\e['
    CLR_MID='m\]'
    CLR_END=$CLR_BEG'0'$CLR_MID

    # most fixed
    PS1_RET=$CLR_BEG'41;1'$CLR_MID'$(r=$?; if [ $r -ne 0 ]; then echo " \\$?=$r ";fi)'$CLR_END
    PS1_LOC=$CLR_BEG'37;100'$CLR_MID" $OS_NICKNAME"$CLR_BEG'95;1'$CLR_MID' \u'$CLR_BEG'30'$CLR_MID'@'$CLR_BEG'32'$CLR_MID"$(echo $(hostname --all-ip-addresses))"$CLR_BEG'30'$CLR_MID'@'$CLR_BEG'34'$CLR_MID"$EC2_NICKNAME"$CLR_BEG'30'$CLR_MID':'$CLR_BEG'33'$CLR_MID'$PWD '$CLR_END
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
    PS1=$PS1_RET$PS1_SHLVL$PS1_LOGIN$PS1_GRP$PS1_PYVENV$PS1_GIT$PS1_LOC$PS1_PMT

    unset EC2_ID EC2_REGION EC2_TAGS_ORI EC2_TAG_NAME EC2_NICKNAME
    unset GIT_PMT_LIST CLR_BEG CLR_MID CLR_END PS1_RET PS1_LOC PS1_PMT PS1_SHLVL PS1_LOGIN PS1_GRP PS1_PYVENV PS1_GIT

fi # interactive shell

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
fi # avoid duplicated source
