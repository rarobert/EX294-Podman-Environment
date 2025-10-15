#!/bin/bash
sudo dnf install podman podman-compose -y
read -p "Container root password: (qwerty) " ROOT_PASSWORD
if [[ $ROOT_PASSWORD ]] then
    ARGS=('--build-arg=ROOT_PASSWORD=${ROOT_PASSWORD}')
fi

podman build -t ex294:10-ubi-init -f lab/Containerfile ${ARGS[@]}.
unset ROOT_PASSWORD

# --env-file file
podman compose -p ex294-practice-env -f lab/compose.yml up --detach

podman exec -it ex294_control /bin/bash
