FROM ubuntu:22.04

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Set up shell
RUN echo 'export PS1="\u@\h:\w\$ "' >> ~/.bashrc