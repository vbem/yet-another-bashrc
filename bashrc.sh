#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090,SC1091,SC2016
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

# must interactive shell, avoid duplicated source
[[ $- == *i* ]] || return
[[ -v YET_ANOTHER_BASHRC ]] && return
YET_ANOTHER_BASHRC="$(realpath "${BASH_SOURCE[0]}")" && declare -r YET_ANOTHER_BASHRC

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# common aliases
alias .dotenv='[[ -r .env ]] && { set -o allexport; source .env; set +o allexport; }'
alias .ls='ls --almost-all -l --classify --human-readable --time-style=long-iso --color=auto'
alias .tree='tree -fiapughDFCN --timefmt %F_%T --du --dirsfirst'
alias .grep='grep -E -n --color=auto'
alias .diff='diff -y'
alias .date='date --iso-8601=sec'
alias .netstat='netstat -ltnpe'
alias .ss='ss -ltnpe'
alias .ps='ps ux'
alias .pstree='pstree -up'
alias .pidof='pidof -x'
alias .grep.code='grep -E -v "^[[:space:]]*$|^[[:space:]]*#"'
alias .nginx.reload='sudo nginx -t && sudo systemctl reload nginx'
alias .export.proxy.socks5='export ALL_PROXY=socks5h://localhost'
alias .curl.header='curl -sv -o /dev/null'
alias .curl.ip='curl -s -4 myip.ipip.net'
alias .kubectl.get.roletable="kubectl get rolebindings,clusterrolebindings -A -o jsonpath=\"{range .items[*]}{.metadata.namespace}/{.kind}/{.metadata.name}{' | '}{.roleRef.kind}/{.roleRef.name}{' | '}{range .subjects[*]}({.namespace}/{.kind}/{.name}){end}{'\n'}{end}\""
alias .clean.home='rm -rf ~/.viminfo ~/.wget-hsts ~/.lesshst ~/.bashdb_hist ~/.python_history ~/*-ks.cfg ~/.cache/ ~/.pki/ ~/.oracle_jre_usage/ ~/.config/htop/'

# golang 🐹
alias .go.setup.system=$'sudo rm -rf /usr/local/go/ && curl -L https://go.dev/dl/$(curl -Ls https://go.dev/dl/?mode=json | jq -Mcre ".[0].version").linux-amd64.tar.gz | sudo tar --directory /usr/local/ --extract --gzip && sudo tee /etc/profile.d/golang.sh <<< \'export PATH=$PATH:/usr/local/go/bin\' >/dev/null && source /etc/profile.d/golang.sh && go version'
alias .go.setup.user=$'rm -rf ~/.local/go/ && mkdir -p ~/.local/go/ \
  && curl -L https://go.dev/dl/$(curl -Ls https://go.dev/dl/?mode=json | jq -Mcre ".[0].version").linux-amd64.tar.gz \
  | tar --directory ~/.local/ --extract --gzip \
  && echo \'export PATH=$PATH:~/.local/go/bin\''

# python 🐍
# https://docs.python.org/3/library/venv.html
# shellcheck disable=SC2139,SC2012
alias .py.latest="$(ls -a /usr/bin/python?.* 2>/dev/null | sort -V | tail -1)"
alias .py.venv.create='.py.latest -m venv --symlinks --clear --upgrade-deps'
function .py.venv.activate { . "${1:-.venv}"/bin/activate; }
alias .py.venv.status='python -c "import sys; exit(0 if sys.prefix!=sys.base_prefix else 1)"'
alias .py.venv.path='echo $VIRTUAL_ENV'
alias .py.cache.clean='find . -type d -name __pycache__ -exec rm -rf {} +'

# docker 🐳
alias .docker.system.prune='docker system prune --all --force --volumes'
alias .docker.container.prune='docker container prune --force'
alias .docker.network.prune='docker network prune --force'
alias .docker.image.prune='docker image prune --all --force'
alias .docker.volume.prune='docker volume prune --all --force'
alias .docker.history='docker history --no-trunc'
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

# WSL 🏘️
alias .wsl.explorer='explorer.exe .'
alias .wsl.interop.off='echo 0 > /proc/sys/fs/binfmt_misc/WSLInterop'
alias .wsl.interop.on='echo 1 > /proc/sys/fs/binfmt_misc/WSLInterop'

# VS code 🆚
alias .imgcat='curl -Ls "https://iterm2.com/utilities/imgcat" | bash -s --'
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
if timeout 0.1 curl -s -m 1 http://100.100.100.200 >/dev/null; then
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
elif timeout 0.1 curl -s -m 1 http://169.254.169.25 >/dev/null; then
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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# for PS1

# color wrapper https://misc.flogisoft.com/bash/tip_colors_and_formatting
beg='\[\e['
end='m\]'
rst=$beg'0'$end

# start PS1
PS1=$rst

# error return code indicator
# shellcheck disable=SC2154
PS1+='$(r=$? && (( $r )) && echo "'$beg'31;103'$end' ⛔ $r ")'

# git indicator
# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Bash
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PMT_LIST=(
    '/usr/share/git-core/contrib/completion/git-prompt.sh'
)
for f in "${GIT_PMT_LIST[@]}"; do
    [[ ! -r "$f" ]] && continue
    declare -r GIT_PS1_SHOWDIRTYSTATE=1
    declare -r GIT_PS1_SHOWSTASHSTATE=1
    declare -r GIT_PS1_SHOWUNTRACKEDFILES=1
    declare -r GIT_PS1_SHOWUPSTREAM="verbose legacy git"
    declare -r GIT_PS1_DESCRIBE_STYLE=branch
    source "$f"
    # shellcheck disable=SC2154
    PS1+='$(g="$(__git_ps1 %s)"; [[ -n "$g" ]] && echo "'$beg'97;44'$end' 🔀 $g ")'
    break
done
unset GIT_PMT_LIST

# python venv indicator
export VIRTUAL_ENV_DISABLE_PROMPT=1
# shellcheck disable=SC2154
PS1+='$([[ -n "$VIRTUAL_ENV" ]] && { p="${VIRTUAL_ENV%/.venv}"; v="$(grep -oP "^version *= *\K.+" "$VIRTUAL_ENV/pyvenv.cfg" 2>/dev/null)"; echo "'$beg'97;46'$end' 🐍 ${p##*/}/$v "; })'

# other indicators
RAW_OTHERS=''
[[ "$TERM_PROGRAM" == "vscode" ]] && RAW_OTHERS+=' 🆚'
shopt -q login_shell || RAW_OTHERS+=' 🔓'
[[ -n "$RAW_OTHERS" ]] && PS1+=$beg'42'$end"$RAW_OTHERS "
unset RAW_OTHERS

# OS indicator
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    RAW_OS="🏘️"
elif [[ -f /.dockerenv ]]; then
    RAW_OS="🐳"
elif [[ -z "$SSH_CLIENT" ]] && [[ -z "$SSH_TTY" ]]; then
    RAW_OS="🖥️"
else
    RAW_OS="☁️"
fi
if [[ -f /etc/os-release ]]; then
    RAW_OS+=" $(source /etc/os-release && echo "$ID-$VERSION_ID")"
elif [[ -n "$(command -v lsb_release 2>/dev/null)" ]]; then
    RAW_OS+=" $(lsb_release -is)-$(lsb_release -rs)"
elif [[ -f /etc/system-release-cpe ]]; then
    RAW_OS+=" $(awk -F: '{ print $3"-"$5 }' </etc/system-release-cpe)"
elif [[ -f /etc/system-release ]]; then
    RAW_OS+=" $(cat /etc/system-release)"
else
    RAW_OS+=" unknown"
fi
PS1+=$beg'97;100'$end" $RAW_OS "
unset RAW_OS

# location indicator
dim=$beg'2;90'$end
PS1+=$beg'1;3;95;49'$end' \u'$dim'@'$beg'22;32'$end"$(hostname -I | cut -d' ' -f1)"$dim'@'$beg'22;33'$end'\H'$dim':'$beg'22;1;94'$end'$PWD'

# prompt
PS1+=$rst'\n'$beg'1;31'$end'\$'$rst' '

unset beg end rst dim

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# auto completions

# kubectl completion https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#enable-shell-autocompletion
command -v kubectl &>/dev/null && source <(kubectl completion bash 2>/dev/null)

# rclone completion https://rclone.org/commands/rclone_completion/
command -v rclone &>/dev/null && source <(RCLONE_CONFIG=/dev/null rclone completion bash 2>/dev/null)

# yq completion https://mikefarah.gitbook.io/yq/commands/shell-completion#bash-default
command -v yq &>/dev/null && source <(yq shell-completion bash 2>/dev/null)

# aliyun completion https://help.aliyun.com/document_detail/122038.html
command -v aliyun &>/dev/null && complete -C "$(command -v aliyun)" aliyun

# helm completion https://helm.sh/docs/helm/helm_completion_bash/
command -v helm &>/dev/null && source <(helm completion bash 2>/dev/null)

# terraform completion https://www.terraform.io/docs/cli/commands/index.html#shell-tab-completion
command -v terraform &>/dev/null && complete -C "$(command -v terraform)" terraform

# Go Command completion https://pkg.go.dev/github.com/posener/complete/v2
command -v go &>/dev/null && gocomplete="$(go env GOPATH)/bin/gocomplete" && [[ -x "$gocomplete" ]] && {
    complete -C "$gocomplete" go
    unset gocomplete
}

# hstr setup https://github.com/dvorka/hstr?tab=readme-ov-file#configuration
# dynamic load will swallow inputs during bash startup:
# command -v hstr &> /dev/null && source <(hstr --show-bash-configuration 2> /dev/null)
# so we use the following instead:
command -v hstr &>/dev/null && {
    alias hh=hstr                   # hh to be alias for hstr
    export HSTR_CONFIG=hicolor      # get more colors
    shopt -s histappend             # append new history items to .bash_history
    export HISTCONTROL=ignorespace  # leading space hides commands from history
    export HISTFILESIZE=10000       # increase history file size (default is 500)
    export HISTSIZE=${HISTFILESIZE} # increase history size (default is 500)
    # ensure synchronization between bash memory and history file
    [[ -n "$PROMPT_COMMAND" ]] && export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    # if this is interactive shell, then bind 'kill last command' to Ctrl-x k
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
    export HSTR_TIOCSTI=y
}

:
