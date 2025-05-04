FROM jenkins/jenkins:lts

USER root

# Set Debian codename manually for the Docker repo (Debian base, not Ubuntu!)
ENV DEBIAN_CODENAME=bookworm

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
        gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/debian $DEBIAN_CODENAME stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean

USER jenkins
