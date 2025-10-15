#!/bin/bash

read -p "This will destroy the current stack (if any): y/N " CONTINUE

case $CONTINUE in
    [Yy]* ) continue;;
    * ) exit;;
esac

podman compose -f lab/compose.yml down
podman network rm ex294_env
exec bin/deploy.sh
