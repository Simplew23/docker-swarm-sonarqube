#!/bin/bash

SERVICE_NAME=$1; shift

TASK_ID=$(docker service ps --filter 'desired-state=running' $SERVICE_NAME -q)
NODE_ID=$(docker inspect --format '{{ .NodeID }}' $TASK_ID)
CONTAINER_ID=$(docker inspect --format '{{ .Status.ContainerStatus.ContainerID }}' $TASK_ID)
NODE_HOST=$(docker node inspect --format '{{ .Description.Hostname }}' $NODE_ID)
export DOCKER_HOST="tcp://$NODE_HOST:2376"

# Execution example: ./service-exec.sh sonarqube_db pg_dump -U sonar -Fc sonar | gzip > /opt/backup/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz
docker exec -t $CONTAINER_ID "$@"
