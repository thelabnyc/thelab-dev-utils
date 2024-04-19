# thelab-dev-utils

This repository containers a build process and Dockerfile for a docker image which contains commonly needed developer utilities. It is intended to be used when running some scripts and processes in other projects, such as the Dev/Staging -> Local DB restore script. Running scripts inside this container instead of directly on the Dev's workstation reduces the needs of what must be installed on the workstation and reduces problems issues caused by disparate versions of utilities.

## Usage

First, include this image in another project's docker-compose file, have it mount the user's home directory and docker socket.

```yaml
services:

   # Other services go here...

  devutils:
    image: registry.gitlab.com/thelabnyc/thelab-dev-utils:latest
    environment:
      HOME: "${HOME}"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "${HOME}:${HOME}"
    working_dir: "${PWD}"
```

Notes about this configuration:

- The `HOME` environment variable is injected so that it matches your workstation.
- The docker socket is mounted so that you can control the host's docker daemon from within the container. The docker client is pre-installed in the image.
- The user's home directory is mounted as a volume so that all the user's file's are accessible in the container.
- The working directory is set to the current working directory of the user at the time of starting the container. This means that relative paths are the same inside and outside of the container.

Now that the image is added to your `docker compose` configuration, a script you used to run like this:

```bash
~/my-project$ ./bin/foo.sh
```

You may now run like this:

```bash
~/my-project$ ./bin/dcd run --rm devutils ./bin/foo.sh
```
