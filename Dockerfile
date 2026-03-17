ARG BASE_IMAGE_TAG="24.04@sha256:0d39fcc8335d6d74d5502f6df2d30119ff4790ebbb60b364818d5112d9e3e932"
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
COPY --from=greenmask/greenmask:latest@sha256:b690fc91ca4a1a217b15aa6b4cda929772bcb3d6028467acbc6322ce64ffbeef /usr/bin/greenmask /usr/bin/

# Create working directory
RUN mkdir -p /code
WORKDIR /code
