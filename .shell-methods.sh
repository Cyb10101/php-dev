#!/usr/bin/env bash

COLOR_RESET=$(echo -en '\001\033[0m\002')
COLOR_RED=$(echo -en '\001\033[00;31m\002')
COLOR_GREEN=$(echo -en '\001\033[00;32m\002')
COLOR_YELLOW=$(echo -en '\001\033[00;33m\002')
COLOR_BLUE=$(echo -en '\001\033[00;34m\002')
COLOR_MAGENTA=$(echo -en '\001\033[00;35m\002')
COLOR_PURPLE=$(echo -en '\001\033[00;35m\002')
COLOR_CYAN=$(echo -en '\001\033[00;36m\002')
COLOR_LIGHTGRAY=$(echo -en '\001\033[00;37m\002')
COLOR_LRED=$(echo -en '\001\033[01;31m\002')
COLOR_LGREEN=$(echo -en '\001\033[01;32m\002')
COLOR_LYELLOW=$(echo -en '\001\033[01;33m\002')
COLOR_LBLUE=$(echo -en '\001\033[01;34m\002')
COLOR_LMAGENTA=$(echo -en '\001\033[01;35m\002')
COLOR_LPURPLE=$(echo -en '\001\033[01;35m\002')
COLOR_LCYAN=$(echo -en '\001\033[01;36m\002')
COLOR_WHITE=$(echo -en '\001\033[01;37m\002')

# Set Terminal title
userTerminalTitle() {
    echo -e '\033]2;'$1'\007'
}

# Set Terminal title - current folder
userTerminalTitlePwd() {
    echo -e '\033]2;'$(pwd)'\007'
}

# Set current user color
userColorUser() {
    if [[ $EUID -eq 0 ]]; then
        echo "${COLOR_LRED}";
    else
        echo "${COLOR_LGREEN}";
    fi
}

# Render Git branch for PS1
renderGitBranch() {
    if [ -f $(which git) ]; then
        echo "${COLOR_YELLOW}$(__git_ps1)"
    fi
}

# @deprecated Check if ssh-agent process is not running and start it
sshAgentRestart() {
    if ! kill -0 ${SSH_AGENT_PID} 2> /dev/null; then
        eval `$(which ssh-agent) -s`;
    fi
}

# @deprecated Check if ssh-agent process is running and add ssh key
# Run: sshAgentAddKey 24h ~/.ssh/id_rsa
sshAgentAddKey() {
    if kill -0 ${SSH_AGENT_PID} 2> /dev/null; then
        if [ -f ${2} ]; then
            if ! ssh-add -l | grep -q `ssh-keygen -lf ${2}  | awk '{print $2}'`; then
                ssh-add -t ${1} ${2};
            fi
        fi
    fi
}

# @deprecated Run SSH Agent and add key 7 days
sshAgentAddKeyOld() {
    if [ -f ~/.ssh/id_rsa ] && [ -z "$SSH_AUTH_SOCK" ] ; then
        eval `ssh-agent -s`
        ssh-add -t 604800 ~/.ssh/id_rsa
    fi
}

# Style bash prompt
stylePS1() {
    VAR_HOSTNAME=`hostname`
    if [ ! -z "$1" ] || [ "$1" != "" ]; then
        VAR_HOSTNAME="${1}"
    fi;

    PS1='$(userTerminalTitlePwd)'
    PS1+='${COLOR_CYAN}['
    PS1+='$(userColorUser)\u${COLOR_CYAN}@${COLOR_LBLUE}${VAR_HOSTNAME}${COLOR_CYAN}: ${COLOR_RESET}\w'
    PS1+='${COLOR_CYAN}]'
    PS1+='$(renderGitBranch)${COLOR_CYAN}> $(userColorUser)\n\$${COLOR_RESET} ';
}

# Style bash prompt
bashCompletion() {
  if [ -f $(which git) ]; then
      source /usr/share/bash-completion/completions/git
      source /etc/bash_completion.d/git-prompt
  fi
}

# Shortcuts in bash
addAlias() {
    # grep
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'

    # List directory
    alias l='ls -vC --color=auto --group-directories-first'
    alias la='ls -vA --color=auto --group-directories-first'
    alias ll='ls -vahl --color=auto --group-directories-first'
    alias ls='ls -v --color=auto --group-directories-first'

    # List directory https://the.exa.website/
    if [ -x /usr/bin/exa ]; then
        alias l='exa --group-directories-first'
        alias la='exa -a --group-directories-first'
        alias ll='exa -ahl --git --header --group --group-directories-first'
        alias ls='exa --group-directories-first'
    fi

    # Change directory
    alias ..='cd ..'
    alias cd..='cd ..'

    # Get current unixtime
    alias unixtime='date +"%s"'

    # Show all open ports
    alias ports='netstat -tulanp'

    # less
    alias less='less -FSRX'
}

addDockerVariables() {
    CONTAINER_ID=$(cat /etc/hostname)

    if test -S "/var/run/docker.sock"; then
        DOCKER_COMPOSE_PROJECT=$(sudo docker inspect ${CONTAINER_ID} | grep '"com.docker.compose.project":' | awk '{print $2}' | tr --delete '"' | tr --delete ',')
    fi
}
