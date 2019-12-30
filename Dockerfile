ARG FROM=webdevops/php-apache-dev:7.4
FROM $FROM

# Bugfix apt cleanup
RUN rm -rf /var/lib/apt/lists/*

RUN \
    apt-get update && \
    apt-get install -y sudo less vim nano diffutils tree git-core bash-completion zsh htop mariadb-client iputils-ping && \
    usermod -aG sudo application && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    update-alternatives --set editor /usr/bin/vim.basic && \
    curl -fsSL https://get.docker.com/ | sh && \
    mkdir /tmp/docker-files

COPY .bashrc-additional.sh /tmp/docker-files/
COPY apache/apache.conf /opt/docker/etc/httpd/vhost.common.d/
COPY entrypoint.d/* /entrypoint.d/
COPY bin/* /usr/local/bin/

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

RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc && \
    composer global require hirak/prestissimo davidrjonas/composer-lock-diff

COPY .shell-methods.sh .vimrc .zshrc /home/application/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /home/application/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/.oh-my-zsh/custom/themes/

USER root

# Set user permissions
RUN chown -R application:application /home/application

ENV \
    POSTFIX_RELAYHOST="[global-mail]:1025" \
    PHP_DISMOD="ioncube" \
    PHP_DISPLAY_ERRORS="1" \
    PHP_MEMORY_LIMIT="-1"

# set apache user group to application:
RUN if [ -f /etc/apache2/envvars ]; then sed -i 's/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=application/g' /etc/apache2/envvars ; fi
RUN if [ -f /etc/apache2/envvars ]; then sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=application/g' /etc/apache2/envvars ; fi
# set nginx user group to application:
RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i 's/user www-data;/user application application;/g' /etc/nginx/nginx.conf ; fi

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
