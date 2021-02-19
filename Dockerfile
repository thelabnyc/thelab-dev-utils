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
RUN apt-get install -y software-properties-common && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" && \
    apt-get update && \
    apt-get install -y postgresql-${POSTGRES_VERSION}

# Install Docker client
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce && \
    pip3 install 'docker-compose==1.28.4'

# Install other misc utils
RUN apt-get install -y dialog unzip jq && \
    pip3 install awscli

# Create working directory
RUN mkdir -p /code
WORKDIR /code
