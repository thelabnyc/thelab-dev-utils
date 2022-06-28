ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

# Install Python
RUN apt-get update && \
    apt-get install -y wget python3 python3-pip && \
    pip3 install --upgrade pip ipython

# Configure Timezone
ARG TIMEZONE="America/New_York"
RUN echo "${TIMEZONE}" > /etc/timezone && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq tzdata

# Install PostgreSQL client
ENV POSTGRES_VERSION "12"
RUN apt-get install -y software-properties-common curl && \
    mkdir -p /etc/apt/keyrings  && \
    curl -fsSL "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | gpg --dearmor -o "/etc/apt/keyrings/postgres.gpg" && \
    echo "deb [signed-by=/etc/apt/keyrings/postgres.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
    apt-get update && \
    apt-get install -y postgresql-${POSTGRES_VERSION}

# Install Docker client
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates software-properties-common && \
    mkdir -p /etc/apt/keyrings  && \
    curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor -o "/etc/apt/keyrings/docker.gpg" && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin && \
    pip3 install 'docker-compose>=1.28.4,<2.0'

# Install other misc utils
RUN apt-get install -y dialog unzip jq && \
    pip3 install awscli

# Create working directory
RUN mkdir -p /code
WORKDIR /code
