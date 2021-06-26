# # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # #
# @name: yet-another-bashrc
# @os: centos/ubuntu
# @version: 2021.06.21
# @usage: https://github.com/vbem/yet-another-bashrc

# Loading order of bashrc mentioned in 'man bash':

# CentOS:
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

# Ubuntu:
# if login shell
#     source /etc/profile
#         if $PS1 # interactive
#             if "$BASH" != "/bin/sh"
#                 source /etc/bash.bashrc
#                     if not $PS1 # not interactive
#                         return # don't do anything
#                     configure checkwinsize
#                     configrue $debian_chroot
#                     if not SUDOing
#                         configure $PS1
#                     print sudo hint
#                     if the command-not-found package is installed, use it
#             else
#                 PS1='# ' or '$ '
#         source /etc/profile.d/*.sh
#     source ~/.profile
#         source ~/.bashrc
#             if not $PS1 # not interactive
#                 return # don't do anything
#             configure history
#             configure lesspipe
#             configure $debian_chroot
#             configure $PS1 on $color_prompt
#             configure aliases
#             source ~/.bash_aliases
# else if interactive
#     source /etc/bash.bashrc
#         SEE ABOVE
#     source ~/.bashrc
#         SEE ABOVE

[[ $- == *i* ]] || return # must interactive shell
[ -v YET_ANOTHER_BASHRC ] && return # # avoid duplicated source
export YET_ANOTHER_BASHRC=$(realpath ${BASH_SOURCE[0]}) # sourced sential

# https://github.com/pypa/setuptools/issues/1458#issuecomment-574076414
# export PYTHONWARNINGS=ignore:::pkg_resources.py2_warn

# Do not pipe output into a pager, see `man systemctl`
export SYSTEMD_PAGER=

# colorful manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# common aliases
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

# cloud aliases
if timeout 0.01 ping -c1 100.100.100.200 > /dev/null; then
    alias .aliyun.use.role='aliyun --mode EcsRamRole --ram-role-name $(curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/) --region $(curl -s 100.100.100.200/latest/meta-data/region-id)'
    alias .aliyun.set.role='aliyun configure set --profile default --mode EcsRamRole --ram-role-name $(curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/) --region $(curl -s 100.100.100.200/latest/meta-data/region-id)'
    alias .ecs.account='curl -s 100.100.100.200/latest/meta-data/owner-account-id'
    alias .ecs.region='curl -s 100.100.100.200/latest/meta-data/region-id'
    alias .ecs.zone='curl -s 100.100.100.200/latest/meta-data/zone-id'
    alias .ecs.account='curl -s 100.100.100.200/latest/meta-data/owner-account-id'
    alias .ecs.cidr='curl -s 100.100.100.200/latest/meta-data/vswitch-cidr-block'
    alias .ecs.hostname='curl -s 100.100.100.200/latest/meta-data/hostname'
    alias .ecs.id='curl -s 100.100.100.200/latest/meta-data/instance-id'
    alias .ecs.type='curl -s 100.100.100.200/latest/meta-data/instance/instance-type'
    alias .ecs.role='curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/'
    alias .ecs.sts='curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/$(curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/)'
    alias .ecs.tags='aliyun --mode EcsRamRole --ram-role-name $(curl -s 100.100.100.200/latest/meta-data/ram/security-credentials/) --region $(curl -s 100.100.100.200/latest/meta-data/region-id) ecs DescribeInstances --InstanceIds ["\"$(curl -s 100.100.100.200/latest/meta-data/instance-id)\""] | jq -Mcr "[.Instances.Instance[].Tags.Tag[]|{(.TagKey):.TagValue}]|add"'
elif timeout 0.01 ping -c1 169.254.169.25 > /dev/null; then
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
fi

# for PS1

# vars
if [ "$WSL_DISTRO_NAME" ]; then
    OS_NICKNAME=WSL-$WSL_DISTRO_NAME
elif [ -f /etc/os-release ]; then
    OS_NICKNAME=$(source /etc/os-release && echo $ID-$VERSION_ID)
elif [ "$(which lsb_release 2> /dev/null)" ]; then
    OS_NICKNAME=$(lsb_release -is)-$(lsb_release -rs)
elif [ -f /etc/system-release-cpe ]; then
    OS_NICKNAME=$(cat /etc/system-release-cpe | awk -F: '{ print $3"-"$5 }')
elif [ -f /etc/system-release ]; then
    OS_NICKNAME=$(cat /etc/system-release)
else
    OS_NICKNAME="unknown-os"
fi

#color wrapper https://misc.flogisoft.com/bash/tip_colors_and_formatting
a='\[\e[0m\]\[\e['
b='m\]'
c=$a'0'$b
x1=$a'2;90;40'$b

# parts
PS1_LOC=$a'95;40'$b' \u'$a'1;35;40'$b'$([ "$(id -ng)" != "$(id -nu)" ] && echo ":$(id -ng)")'$x1'@'$a'3;32;40'$b"$(echo $(hostname --all-ip-addresses))"$x1'@'$a'4;34;40'$b'\H'$x1':'$a'1;33;40'$b'$PWD '$c
PS1_PMT='\n'$a'1;31'$b'\$'$c' '
PS1_RET=$a'1;97;41'$b'$(r=$?; [ $r -ne 0 ] && echo " \\$?=$r ")'$c
if [ -v DISPLAY -a -v WSL_DISTRO_NAME ]; then # in WSL and MobaXterm
    PS1_SHLVL=$a'1;97;43'$b'$([ 2 -lt $SHLVL ] && echo " \\$SHLVL=$SHLVL ")'$c # WSL-CentOS case only
else
    PS1_SHLVL=$a'1;97;43'$b'$([ 1 -ne $SHLVL ] && echo " \\$SHLVL=$SHLVL ")'$c
fi
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
unset OS_NICKNAME
unset a b c x1
unset GIT_PMT_LIST PS1_RET PS1_LOC PS1_PMT PS1_SHLVL PS1_LOGIN PS1_PYVENV PS1_GIT PS1_OS

# terminal title
#[ -z "$PROMPT_COMMAND" ] && PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

# bash cmd history
export HISTTIMEFORMAT="%F_%T "
[ "$(which hh 2> /dev/null)" ] && eval "$(hh --show-configuration)"

# shell completions
[ "$(which kubectl 2> /dev/null)" ] && source <(kubectl completion bash)
[ "$(which aliyun 2> /dev/null)" ] && complete -C $(which aliyun) aliyun
[ "$(which helm 2> /dev/null)" ] && source <(helm completion bash)
[ "$(which yq 2> /dev/null)" ] && source <(yq shell-completion bash)
[ "$(which rclone 2> /dev/null)" ] && source <(rclone -q genautocomplete bash -)

# # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # # YET_ANOTHER_BASHRC # # #
