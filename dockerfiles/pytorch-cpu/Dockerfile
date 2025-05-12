FROM quay.io/jupyter/pytorch-notebook:x86_64-pytorch-2.6.0

# Define build arguments for username and password
ARG USERNAME=ailabuser
# Password will be passed as a build secret

USER root
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
# WORKDIR /ailabenv
WORKDIR "${HOME}"

# Install required packages
RUN apt update && apt install -y screen sudo openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH, generate SSH host keys, and create user with BuildKit secret
RUN --mount=type=secret,id=user_password \
    mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    # Generate SSH host keys
    ssh-keygen -A && \
    # Create user with sudo privileges
    useradd -m -s /bin/bash ${USERNAME} && \
    echo "${USERNAME}:$(cat /run/secrets/user_password 2>/dev/null || cat /dev/null)" | chpasswd && \
    usermod -aG sudo ${USERNAME} && \
    # Allow user to use sudo without password
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${NB_USER} && \
    chmod 0440 /etc/sudoers.d/${NB_USER}

# RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' -o vscode_cli.tar.gz && tar -xf vscode_cli.tar.gz

COPY --chown=${NB_UID}:${NB_GID} requirements.txt .
COPY --chown=${NB_UID}:${NB_GID} --chmod=755 startup.sh .


RUN pip install --no-cache-dir -r requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_USER}
# Expose SSH port
EXPOSE 22 8888

CMD ["./startup.sh"]
