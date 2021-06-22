# yet-another-bashrc
A general bashrc attachment with personalized prompt and aliases.

## What is "yet-another-bashrc"?
Every skillful Linuxer has a *personalized snippet of `.bashrc`* to customize interactive shell prompt and aliases, but how one keeps consistent of it among many machines especially on cloud hosts like AWS EC2 and others. A version controled, via-HTTP available snippet is generally needed, with custom features.

## Snapshot:
![snapshot](https://raw.githubusercontent.com/vbem/remote-bashrc/master/img/snapshot.png)

## Usage:
### Load automaticly:
```sh
# for current user:
echo '[ -v YET_ANOTHER_BASHRC ] || source <(curl -s -m 2 --retry 1 https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)' >> ~/.bashrc

# for all users:
sudo echo '[ -v YET_ANOTHER_BASHRC ] || source <(curl -s -m 2 --retry 1 https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)' >> /etc/bashrc
```

### Load manually:
```sh
# add a following command as a hotkey to your SSH client like Xshell or Putty and etc.
source <(curl -s https://raw.githubusercontent.com/vbem/yet-another-bashrc/master/bashrc.sh)
```

### Personalize:
Fork -> Edit -> Enjoy
