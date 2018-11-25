FROM golang AS mhsendmail
RUN go get github.com/mailhog/mhsendmail

FROM webdevops/php-apache-dev:7.2

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=mhsendmail /go/bin/mhsendmail /home/application/go/bin/mhsendmail

RUN \
    echo "deb http://deb.debian.org/debian stretch universe" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch-updates universe" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch multiverse" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch-updates multiverse" >> /etc/apt/sources.list && \
    apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y sudo less vim nano diffutils tree git-core bash-completion zsh htop && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG sudo application && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    update-alternatives --set editor /usr/bin/vim.basic

# Configure root
RUN echo "source ~/.shell-methods" >> ~/.bashrc && \
    echo "addAlias" >> ~/.bashrc && \
    echo "stylePS1" >> ~/.bashrc && \
    echo "bashCompletion" >> ~/.bashrc && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

COPY .shell-methods .zshrc .oh-my-zsh/custom/themes/cyb.zsh-theme /root/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /root/.oh-my-zsh/custom/themes/cyb.zsh-theme

# Configure user
USER application
RUN composer global require hirak/prestissimo

RUN echo "source ~/.shell-methods" >> ~/.bashrc && \
    echo "addAlias" >> ~/.bashrc && \
    echo "stylePS1" >> ~/.bashrc && \
    echo "bashCompletion" >> ~/.bashrc && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

COPY .shell-methods .zshrc .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/
COPY .oh-my-zsh/custom/themes/cyb.zsh-theme /home/application/.oh-my-zsh/custom/themes/cyb.zsh-theme

#USER root
