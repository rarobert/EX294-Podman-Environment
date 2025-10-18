#!/bin/bash
podman compose -f lab/compose.yml down
podman network rm ex294_env
podman rmi ex294:10-ubi
