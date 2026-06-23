ARG BASE_IMAGE_TAG="26.04@sha256:53958ec7b67c2c9355df922dd08dbf0360611f8c3cdb656875e81873db9ffdba"
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
COPY --from=greenmask/greenmask:latest@sha256:927fbbaffd9ba95aa5d33ba90a11ea9b631e631bbade4f6d38e20c8755016bfb /usr/bin/greenmask /usr/bin/

# Create working directory
RUN mkdir -p /code
WORKDIR /code
