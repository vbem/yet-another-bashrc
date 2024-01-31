#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090,SC2154
# https://github.com/vbem/yet-another-bashrc

# Loading order of bashrc mentioned in 'man bash':

# RHEL:
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
#                     configure $debian_chroot
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
[[ -v YET_ANOTHER_BASHRC ]] && return # # avoid duplicated source
YET_ANOTHER_BASHRC="$(realpath ${BASH_SOURCE[0]})" && declare -rg YET_ANOTHER_BASHRC # sourced sentinel

# common aliases
alias .ls='ls --almost-all -l --classify --human-readable --time-style=long-iso --color=auto'
alias .tree='tree -fiapughDFCN --timefmt %F_%T --du --dirsfirst'
alias .grep='grep -E -n --color=auto'
alias .diff='diff -y'
alias .date='date +"%F %T %z"'
alias .netstat='netstat -ltnpe'
alias .ss='ss -ltnpe'
alias .ps='ps ux'
alias .pstree='pstree -up'
alias .pidof='pidof -x'
alias .grep.code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
alias .nginx.reload='sudo nginx -t && sudo systemctl reload nginx'
alias .curl.header='curl -sv -o /dev/null'
alias .curl.ip='curl -s -4 myip.ipip.net'
alias .venv.clear='python3 -m venv --clear'
function .venv.activate { . $1/bin/activate; }
alias .pip3.show='pip3 --disable-pip-version-check -v show --files'
alias .pip3.list='pip3 --disable-pip-version-check list --format columns'
alias .pip3.user='pip3 --disable-pip-version-check -v install --user'
alias .ipython3='ipython3 --nosep --no-confirm-exit --no-term-title --no-automagic --colors Linux'
alias .kubectl.get.roletable="kubectl get rolebindings,clusterrolebindings -A -o jsonpath=\"{range .items[*]}{.metadata.namespace}/{.kind}/{.metadata.name}{' | '}{.roleRef.kind}/{.roleRef.name}{' | '}{range .subjects[*]}({.namespace}/{.kind}/{.name}){end}{'\n'}{end}\""
alias .clean.home='rm -rf ~/.viminfo ~/.wget-hsts ~/.lesshst ~/.python_history ~/*-ks.cfg ~/.cache/ ~/.pki/ ~/.oracle_jre_usage/ ~/.config/htop/'

# docker 🐳
alias .docker.system.prune='docker system prune --all --force --volumes'
alias .docker.decode='jq -Mcre ".auths|to_entries[]|.key+\"\t\"+(.value.auth|@base64d)" ~/.docker/config.json'

# dnf 🐧
alias .dnf.cache='sudo dnf clean all && sudo dnf makecache'
alias .dnf.upgrade='sudo dnf upgrade --refresh'
alias .dnf.repolist='dnf repolist --all'
alias .dnf.repo-pkgs='dnf repo-pkgs'
alias .repoquery.list='dnf repoquery --list'
alias .repoquery.file='dnf repoquery --file'
alias .repoquery.requires='dnf repoquery --requires'
alias .repoquery.whatrequires='dnf repoquery --whatrequires'

# Git 🐙
alias .git.log='git log --graph --all --decorate --oneline'
alias .git.config.local.user.name='git config --local user.name'
alias .git.config.local.user.email='git config --local user.email'
alias .git.config.local.list='git config --local --list'

# VS code 🆚
alias .code='code --verbose'
alias .code.add='.code --reuse-window --add'
alias .code.diff='.code --reuse-window --diff'
alias .code.list='.code --list-extensions --show-versions'
alias .code.standalone='mkdir -p ~/bin && curl -Lk "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" | tar -xzC ~/bin && ls -al ~/bin/code && .code --version'
alias .code.tunnel='.code tunnel'
alias .code.tunnel.user='.code.tunnel user'
alias .code.tunnel.status='.code.tunnel status | jq'
alias .code.tunnel.unregister='.code.tunnel unregister'
alias .code.tunnel.service='.code.tunnel service'
alias .code.tunnel.service.ls='ls -al ~/.config/systemd/user/'
alias .code.tunnel.service.status='systemctl --user status code-tunnel.service'
alias .code.tunnel.service.uninstall='.code.tunnel.service uninstall && .code.tunnel.unregister && systemctl --user daemon-reload'
alias .code.tunnel.service.install='systemctl --user daemon-reload && .code.tunnel.service install --accept-server-license-terms --name "${HOSTNAME}" && .code.tunnel.service.ls && sudo loginctl enable-linger "$USER"' # https://wiki.archlinux.org/title/systemd/User

# cloud aliases ☁️
if timeout 0.1 curl -s -m 1 http://100.100.100.200 > /dev/null; then
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
elif timeout 0.1 curl -s -m 1 http://169.254.169.25 > /dev/null; then
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

# Do not pipe output into a pager, see `man systemctl`
export SYSTEMD_PAGER=''

# https://git-scm.com/docs/git#Documentation/git.txt-codeGITPAGERcode
export GIT_PAGER=''

# colorful manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export GROFF_NO_SGR=1

# for PS1

# OS indicator
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    OS_INDICATOR="💻"
elif [[ -f /.dockerenv ]]; then
    OS_INDICATOR="🐳"
else
    OS_INDICATOR="☁️"
fi
if [[ -f /etc/os-release ]]; then
    OS_INDICATOR="${OS_INDICATOR} $(source /etc/os-release && echo $ID-$VERSION_ID)"
elif [[ "$(which lsb_release 2> /dev/null)" ]]; then
    OS_INDICATOR="${OS_INDICATOR} $(lsb_release -is)-$(lsb_release -rs)"
elif [[ -f /etc/system-release-cpe ]]; then
    OS_INDICATOR="${OS_INDICATOR} $(cat /etc/system-release-cpe | awk -F: '{ print $3"-"$5 }')"
elif [[ -f /etc/system-release ]]; then
    OS_INDICATOR="${OS_INDICATOR} $(cat /etc/system-release)"
else
    OS_INDICATOR="${OS_INDICATOR} ❔"
fi

#color wrapper https://misc.flogisoft.com/bash/tip_colors_and_formatting
a='\[\e[0m\]\[\e['
b='m\]'
c="$a"'0'"$b"
x1="$a"'2;90'"$b"

# parts
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    PS1_LOGIN=$a'46'$b' 🆚 '$c
elif ! shopt -q login_shell; then
    PS1_LOGIN=$a'46'$b' 🔓 '$c
else
    PS1_LOGIN=''
fi
PS1_RET=$a'1;91;103'$b'$(r=$? && (( $r )) && echo " ⛔ $r ")'$c
PS1_OS=$a'37;100'$b" $OS_INDICATOR "$c
PS1_LOC=$a'3;95'$b' \u'$a'1;35'$b'$([ "$(id -ng)" != "$(id -nu)" ] && echo ":$(id -ng)")'$x1'@'$a'4;32'$b"$(hostname -I|cut -d' ' -f1)"$x1'@'$a'3;33'$b'\H'$x1':'$a'1;94'$b'$PWD '$c
PS1_PMT='\n'$a'1;31'$b'\$'$c' '
unset OS_INDICATOR

# python venv
export VIRTUAL_ENV_DISABLE_PROMPT=1
PS1_PYVENV=$a'97;42'$b'$([[ -n "$VIRTUAL_ENV" ]] && echo " 🐍$VIRTUAL_ENV ")'$c

# git
# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Bash
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PMT_LIST=(
    '/usr/share/git-core/contrib/completion/git-prompt.sh'
)
for f in "${GIT_PMT_LIST[@]}"; do
    [[ ! -r "$f" ]] && continue
    declare -rg GIT_PS1_SHOWDIRTYSTATE=1;
    declare -rg GIT_PS1_SHOWSTASHSTATE=1;
    declare -rg GIT_PS1_SHOWUNTRACKEDFILES=1;
    declare -rg GIT_PS1_SHOWUPSTREAM="verbose legacy git";
    declare -rg GIT_PS1_DESCRIBE_STYLE=branch;
    declare -rg GIT_PS1_SHOWCOLORHINTS=1;
    source "$f";
    PS1_GIT=$a'3;97;104'$b'$(__git_ps1 " %s ")'$c;
    break;
done

# all PS1
PS1="$PS1_RET$PS1_PYVENV$PS1_GIT$PS1_LOGIN$PS1_OS$PS1_LOC$PS1_PMT"
unset a b c x1
unset GIT_PMT_LIST PS1_RET PS1_LOC PS1_PMT PS1_LOGIN PS1_PYVENV PS1_GIT PS1_OS

# terminal title
#[ -z "$PROMPT_COMMAND" ] && PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]$PS1"

# kubectl completion https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#enable-shell-autocompletion
command -v kubectl &> /dev/null && source <(kubectl completion bash 2> /dev/null)

# rclone completion https://rclone.org/commands/rclone_completion/
command -v rclone &> /dev/null && source <(RCLONE_CONFIG=/dev/null rclone completion bash 2> /dev/null)

# yq completion https://mikefarah.gitbook.io/yq/commands/shell-completion#bash-default
command -v yq &> /dev/null && source <(yq shell-completion bash 2> /dev/null)

# aliyun completion https://help.aliyun.com/document_detail/122038.html
command -v aliyun &> /dev/null && complete -C "$(command -v aliyun)" aliyun

# helm completion https://helm.sh/docs/helm/helm_completion_bash/
command -v helm &> /dev/null && source <(helm completion bash 2> /dev/null)

# terraform completion https://www.terraform.io/docs/cli/commands/index.html#shell-tab-completion
command -v terraform &> /dev/null && complete -C "$(which terraform)" terraform

# hstr setup https://github.com/dvorka/hstr?tab=readme-ov-file#configuration
# dynamic load will swallow inputs during bash startup:
# command -v hstr &> /dev/null && source <(hstr --show-bash-configuration 2> /dev/null)
# so we use the following instead:
command -v hstr &> /dev/null && {
    alias hh=hstr                    # hh to be alias for hstr
    export HSTR_CONFIG=hicolor       # get more colors
    shopt -s histappend              # append new history items to .bash_history
    export HISTCONTROL=ignorespace   # leading space hides commands from history
    export HISTFILESIZE=10000        # increase history file size (default is 500)
    export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
    # ensure synchronization between bash memory and history file
    export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    # if this is interactive shell, then bind 'kill last command' to Ctrl-x k
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
    export HSTR_TIOCSTI=y
}

: