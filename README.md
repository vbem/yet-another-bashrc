# yet-another-bashrc
[![Linter](https://github.com/vbem/yet-another-bashrc/actions/workflows/linter.yml/badge.svg)](https://github.com/vbem/yet-another-bashrc/actions/workflows/linter.yml)

A general `bashrc` fragment with personalized prompt and aliases.

## Snapshot
![snapshot](https://raw.githubusercontent.com/vbem/remote-bashrc/master/img/snapshot.png)

## Usage

For current user:
```bash
echo '
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://ghproxy.com/https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://cdn.jsdelivr.net/gh/vbem/yet-another-bashrc/bashrc.sh)
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)
' >> ~/.bashrc
```

For all users:
```bash
sudo echo '
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://ghproxy.com/https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://cdn.jsdelivr.net/gh/vbem/yet-another-bashrc/bashrc.sh)
[[ -v YET_ANOTHER_BASHRC ]] || source <(curl -Ls -m 3 --retry 1 https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)
' >> /etc/bashrc
```

## Customization
Fork -> Edit -> Enjoy