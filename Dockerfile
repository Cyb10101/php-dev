FROM pluswerk/php-dev:nginx-7.3

# Bugfix apt cleanup
RUN rm -rf /var/lib/apt/lists/*

RUN \
    apt-get update && \
    apt-get install -y diffutils git-core zsh htop && \
    update-alternatives --set editor /usr/bin/vim.basic && \
    mkdir /tmp/docker-files

COPY .bashrc-additional.sh /tmp/docker-files/
COPY apache/apache.conf /opt/docker/etc/httpd/vhost.common.d/
COPY entrypoint.d/* /entrypoint.d/

# Configure root
RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

COPY .shell-methods.sh .vimrc .zshrc /root/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /root/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /root/.oh-my-zsh/custom/themes/

# Configure user
RUN rsync -a /root/.oh-my-zsh/ /home/application/.oh-my-zsh && \
    chown -R application:application /home/application/.oh-my-zsh
USER application

RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc

COPY .shell-methods.sh .vimrc .zshrc /home/application/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /home/application/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/.oh-my-zsh/custom/themes/

USER root
RUN rm -rf /var/lib/apt/lists/*
