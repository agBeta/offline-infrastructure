BIND_MOUNT_PATH := <path/to/verdaccio-bind-mount>
# in this folder structure, it is simply $(pwd)/verdaccio-bind-mount

alias start := start-verdaccio-server
alias rm := rm-server
alias set := set-verdaccio-as-registry-of-project

default:
  @just --list

permit-verdaccio-container-access-data-mount:
    sudo chown -R 10001:65533 {{BIND_MOUNT_PATH}}
    # based on https://verdaccio.org/docs/docker/#running-verdaccio-using-docker.

start-verdaccio-server:
    #!/usr/bin/bash
    # you can append -d after -it.
    V_PATH={{BIND_MOUNT_PATH}}; docker run -it --name verdaccio \
        -p 4873:4873 \
        -v $V_PATH/conf:/verdaccio/conf \
        -v $V_PATH/storage:/verdaccio/storage \
        -v $V_PATH/plugins:/verdaccio/plugins \
        verdaccio/verdaccio:nightly-master

set-verdaccio-as-registry-of-project:
    echo "registry=http://localhost:4873/\noffline=true" > ./consumer-project/.npmrc

stop-rm-server:
    docker rm -f -v verdaccio
    # actually rm is not necessary, since we're using bind mount (not volumes)