#!/usr/bin/env bash
source .env || true
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-${PWD##*/}}
volumes="
${COMPOSE_PROJECT_NAME}_ca_data
${COMPOSE_PROJECT_NAME}_ca_ssl
${COMPOSE_PROJECT_NAME}_db_ssl
${COMPOSE_PROJECT_NAME}_haproxy_ssl
${COMPOSE_PROJECT_NAME}_nats_ssl
${COMPOSE_PROJECT_NAME}_postgres
${COMPOSE_PROJECT_NAME}_r10k_cache
${COMPOSE_PROJECT_NAME}_r10k_env
${COMPOSE_PROJECT_NAME}_r10k_ssl
${COMPOSE_PROJECT_NAME}_server_data
${COMPOSE_PROJECT_NAME}_server_ssl
"

docker-compose rm

case $1 in
  'data' )
    for v in $volumes; do
      echo docker run --rm -v $v:/data busybox sh -c \"rm -rf /data/*\"
      docker run --rm -v $v:/data busybox sh -c "rm -rf /data/*"
    done
    ;;
  'volumes' )
    for v in $volumes; do
      echo docker volume rm $v
      docker volume rm $v
    done
    ;;
esac
