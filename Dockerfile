FROM golang AS mhsendmail
RUN go get github.com/mailhog/mhsendmail

FROM webdevops/php-apache-dev:7.3
COPY --from=mhsendmail /go/bin/mhsendmail /home/application/go/bin/mhsendmail

RUN \
    apt-get update && \
    apt-get install -y sudo less vim nano diffutils tree git-core bash-completion zsh htop mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG sudo application && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    update-alternatives --set editor /usr/bin/vim.basic && \
    mkdir /tmp/docker-files

COPY .bashrc-additional.sh /tmp/docker-files/
COPY apache/apache.conf /opt/docker/etc/httpd/vhost.common.d/
COPY entrypoint.d/entrypoint-cyb.sh /entrypoint.d/

RUN curl -fsSL https://get.docker.com/ | sh

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
