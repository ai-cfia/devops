FROM linuxserver/webtop:ubuntu-kde

## Utils
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    git \
    htop \
    vim \
    net-tools \
    tar \
    unzip \
    make \
    wget \
    default-jre \
    default-jdk

# DBeaver
RUN wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz && \
    tar -zxvf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz && \
    mv dbeaver /usr/share/ && \
    echo -e "[Desktop Entry]\nName=DBeaver\nExec=/usr/share/dbeaver/dbeaver\nIcon=/usr/share/dbeaver/dbeaver.png\nType=Application\nCategories=Development;IDE;" > /usr/share/applications/dbeaver.desktop && \
    chmod +x -R /usr/share/dbeaver/

# Visual Studio Code
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null && \
    apt-get update && apt-get install -y code && \
    rm -f packages.microsoft.gpg
