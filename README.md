# thelab-dev-utils

This repository containers a build process and Dockerfile for a docker image which contains commonly needed developer utilities. It is intended to be used when running some scripts and processes in other projects, such as the Dev/Staging -> Local DB restore script. Running scripts inside this container instead of directly on the Dev's workstation reduces the needs of what must be installed on the workstation and reduces problems issues caused by disparate versions of utilities.

## Usage

First, include this image in another project's docker-compose file, have it mount the user's home directory and docker socker, and have it inherit any needed environment variables (like AWS credentials).

```yaml
version: '2.1'
services:

   # Other services go here...

  devutils:
    image: registry.gitlab.com/thelabnyc/thelab-dev-utils:latest
    environment:
      HOME: "${HOME}"
      AWS_VAULT: "${AWS_VAULT:-}"
      AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION:-us-east-1}"
      AWS_REGION: "${AWS_REGION-us-east-1}"
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
      AWS_SESSION_TOKEN: "${AWS_SESSION_TOKEN:-}"
      AWS_SECURITY_TOKEN: "${AWS_SECURITY_TOKEN:-}"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "${HOME}:${HOME}"
    working_dir: "${PWD}"
```

Notes about this configuration:

- The `HOME` environment variable is injected so that it matches your workstation.
- AWS credentials are injected so that the AWS CLI tools (pre-installed in the image) work just like they would locally.
- The docker socket is mounted so that you can control the host's docker daemon from within the container. The docker client is pre-installed in the image.
- The user's home directory is mounted as a volume so that all the user's file's are accessible in the container.
- The working directory is set to the current working directory of the user at the time of starting the container. This means that relative paths are the same inside and outside of the container.

Now that the image is added to your `docker-compose` configuration, a scirpt you used to run like this:

```bash
~/my-project$ ./bin/foo.sh
```

You may now run like this:

```bash
~/my-project$ ./bin/dcd run --rm devutils ./bin/foo.sh
```
