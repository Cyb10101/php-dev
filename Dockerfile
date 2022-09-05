ARG FROM=webdevops/php-apache-dev:8.1
FROM $FROM

ENV \
    POSTFIX_RELAYHOST="[global-mail]:1025" \
    PHP_DISMOD="ioncube" \
    PHP_DISPLAY_ERRORS="1" \
    PHP_MEMORY_LIMIT="-1" \
    DATE_TIMEZONE="Europe/Berlin"

# Bugfix apt cleanup
RUN rm -rf /var/lib/apt/lists/*

RUN \
    apt-get update && \
    apt-get install -y sudo less vim nano diffutils tree git-core bash-completion zsh htop mariadb-client iputils-ping \
        sshpass gettext ncdu exa jq python3 python3-pip && \
    pip3 install yq && \
    usermod -aG sudo application && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    update-alternatives --set editor /usr/bin/vim.basic && \
    curl -fsSL https://get.docker.com/ | sh && \
    mkdir /tmp/docker-files && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN composer self-update --clean-backups

RUN curl -fsSL "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" -o /usr/local/bin/wp-cli && \
    chmod +x /usr/local/bin/wp-cli

# https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion#comment110879511_59193253
RUN sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml

COPY .bashrc-additional.sh /tmp/docker-files/
COPY apache/apache.conf /opt/docker/etc/httpd/vhost.common.d/
COPY provision/entrypoint.d/* /opt/docker/provision/entrypoint.d/
#COPY entrypoint.d/* /entrypoint.d/
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

RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc

COPY .shell-methods.sh .vimrc .zshrc /home/application/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /home/application/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/.oh-my-zsh/custom/themes/

USER root

# Set user permissions
RUN chown -R application:application /home/application

# set apache user group to application:
RUN if [ -f /etc/apache2/envvars ]; then sed -i 's/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=application/g' /etc/apache2/envvars; fi
RUN if [ -f /etc/apache2/envvars ]; then sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=application/g' /etc/apache2/envvars; fi
# set nginx user group to application:
RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i -E 's/^user\s+(www-data|nginx);/user application application;/g' /etc/nginx/nginx.conf; fi
