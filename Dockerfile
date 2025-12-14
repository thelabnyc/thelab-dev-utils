ARG BASE_IMAGE_TAG="24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54"
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
COPY --from=greenmask/greenmask:latest@sha256:53c7c3c40c8e383b2b778887dc9b2f40bbdd479fe86da077ec36feaa5c1f0670 /usr/bin/greenmask /usr/bin/

# Create working directory
RUN mkdir -p /code
WORKDIR /code
