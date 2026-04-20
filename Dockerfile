ARG BASE_IMAGE_TAG="24.04@sha256:c4a8d5503dfb2a3eb8ab5f807da5bc69a85730fb49b5cfca2330194ebcc41c7b"
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
COPY --from=greenmask/greenmask:latest@sha256:0ceb5fcbcc4f6ddaf2de0a5d8ad8de0ac31ce8d41f766f05453d6f2108cb209b /usr/bin/greenmask /usr/bin/

# Create working directory
RUN mkdir -p /code
WORKDIR /code
