FROM webdevops/php-apache-dev:7.3

RUN \
    apt-get update && \
    apt-get install -y sudo less vim nano diffutils tree git-core bash-completion zsh htop mysql-client iputils-ping && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG sudo application && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    update-alternatives --set editor /usr/bin/vim.basic && \
    mkdir /tmp/docker-files

COPY .bashrc-additional.sh /tmp/docker-files/
COPY apache/apache.conf /opt/docker/etc/httpd/vhost.common.d/
COPY entrypoint.d/* /entrypoint.d/

RUN curl -fsSL https://get.docker.com/ | sh

RUN curl -o /usr/local/bin/mhsendmail -SL "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_$(dpkg --print-architecture)" && \
    chmod +x /usr/local/bin/mhsendmail
ENV PHP_SENDMAIL_PATH="'/usr/local/bin/mhsendmail --smtp-addr=global-mail:1025'"

# Configure root
RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

COPY .shell-methods .vimrc .zshrc /root/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /root/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /root/.oh-my-zsh/custom/themes/

# Configure user
USER application
RUN composer global require hirak/prestissimo davidrjonas/composer-lock-diff

RUN cat /tmp/docker-files/.bashrc-additional.sh >> ~/.bashrc && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

COPY .shell-methods .vimrc .zshrc /home/application/
COPY .oh-my-zsh/custom/plugins/ssh-agent/ssh-agent.plugin.zsh /home/application/.oh-my-zsh/custom/plugins/ssh-agent/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/.oh-my-zsh/custom/themes/

USER root
