ARG BASE_IMAGE_TAG="26.04@sha256:b7f48194d4d8b763a478a621cdc81c27be222ba2206ca3ca6bc42b49685f3d9e"
FROM ubuntu:${BASE_IMAGE_TAG}

# Set the time zone
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install Python and misc utils
ARG PYTHON_VERSION="3.13"
ENV PYTHON_VERSION=${PYTHON_VERSION}
COPY ./bin/install-python.sh /opt/
RUN /opt/install-python.sh
ENV PATH="/root/.local/bin:${PATH}"

# Install AWS CLI
COPY ./bin/install-awscli.sh /opt/
RUN /opt/install-awscli.sh

# Install PostgreSQL client
ARG POSTGRES_VERSION="17"
COPY ./bin/install-postgres.sh /opt/
RUN /opt/install-postgres.sh

# Install Docker client
COPY ./bin/install-docker.sh /opt/
RUN /opt/install-docker.sh

# Install greenmask
COPY --from=greenmask/greenmask:latest@sha256:c810df82c87ab7214a3fe7064e5f082eba66d377e403b84b21f386c20450a378 /usr/bin/greenmask /usr/bin/

# Create working directory
RUN mkdir -p /code
WORKDIR /code
