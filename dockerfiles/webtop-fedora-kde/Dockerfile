FROM linuxserver/webtop:fedora-kde

# Utils
RUN dnf install -y \
    curl \
    python3 \
    git \
    htop \
    vim \
    net-tools \
    tar \
    unzip \
    gcc \
    make \
    wget \
    java-latest-openjdk \
    java-latest-openjdk-devel

# DBeaver
RUN wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz && \
    tar -zxvf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz && \
    mv dbeaver /usr/share/ && \
    echo -e "[Desktop Entry]\nName=DBeaver\nExec=/usr/share/dbeaver/dbeaver\nIcon=/usr/share/dbeaver/dbeaver.png\nType=Application\nCategories=Development;IDE;" > /usr/share/applications/dbeaver.desktop && \
    chmod +x -R /usr/share/dbeaver/ && \
    rm dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# Download Visual Studio Code RPM directly
RUN curl -L -o vscode.rpm https://update.code.visualstudio.com/latest/linux-rpm-x64/stable && \
    dnf install -y vscode.rpm && \
    rm vscode.rpm && \
    dnf clean all
