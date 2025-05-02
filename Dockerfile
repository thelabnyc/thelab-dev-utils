ARG BASE_IMAGE_TAG
FROM ubuntu:${BASE_IMAGE_TAG}

ARG TIMEZONE="America/New_York"

# Install Python and misc utils
RUN export DEBIAN_FRONTEND=noninteractive && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apt-get update && \
    apt-get install -yq \
        apt-transport-https \
        ca-certificates \
        curl \
        dialog \
        jq \
        python3 \
        python3-pip \
        software-properties-common \
        tzdata \
        unzip \
        wget \
    && \
    pip3 install --upgrade \
        awscli \
        ipython \
        pip \
    && \
    rm -rf /var/lib/apt/lists/* && \
    unset DEBIAN_FRONTEND

# Install PostgreSQL client
ENV POSTGRES_VERSION "17"
RUN export DEBIAN_FRONTEND=noninteractive && \
    mkdir -p /etc/apt/keyrings  && \
    curl -fsSL "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | gpg --dearmor -o "/etc/apt/keyrings/postgres.gpg" && \
    echo "deb [signed-by=/etc/apt/keyrings/postgres.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
    apt-get update && \
    apt-get install -yq \
        postgresql-${POSTGRES_VERSION} \
    && \
    rm -rf /var/lib/apt/lists/* && \
    unset DEBIAN_FRONTEND

# Install Docker client
RUN export DEBIAN_FRONTEND=noninteractive && \
    mkdir -p /etc/apt/keyrings  && \
    curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor -o "/etc/apt/keyrings/docker.gpg" && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -yq \
        containerd.io \
        docker-ce \
        docker-ce-cli \
        docker-compose-plugin \
    && \
    rm -rf /var/lib/apt/lists/* && \
    unset DEBIAN_FRONTEND

# Create working directory
RUN mkdir -p /code
WORKDIR /code
