#!/bin/bash -x
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
TIMESTAMP=$(date '+%Y%m%d%H%M%S')

PROJECT_IMAGE="downtek/nginx"
PROJECT_NAME="nginx-example.com"
PROJECT_DOMAIN="example.com"

IDENTIFIER="${PROJECT_DOMAIN}.${TIMESTAMP}"

docker run -i   \
--detach=false  \
--tty=true      \
--rm            \
--hostname="${IDENTIFIER}"       \
--name "${IDENTIFIER}"           \
-v "$DIR/webroot":/var/www       \
--env "SERVICE_NAME=${PROJECT_DOMAIN}" \
--env "SERVICE_TAGS=$PROJECT_NAME,$PROJECT_DOMAIN,$PROJECT_IMAGE"  \
--env "SERVICE_REGION=$(hostname -f)"                \
--env "SERVICE_80_NAME=${PROJECT_NAME}"              \
--env "SERVICE_80_ID=${IDENTIFIER}"                  \
--env "SERVICE_80_CHECK_HTTP=curl localhost"         \
--env "SERVICE_80_CHECK_INTERVAL=5s"                 \
--env "PROJECT_NAME=${PROJECT_NAME}"                 \
--env "DATABASE_HOST=172.17.42.1"                    \
--env "DATABASE_USER=banaan"                         \
--env "DATABASE_PASS=some_password"                  \
--dns "172.17.42.1"                                  \
--dns-search "${PROJECT_DOMAIN}"                     \
$PROJECT_IMAGE /bin/bash







docker run -i       \
    --detach=false  \
    --tty=true      \
    --rm            \

    --dns "8.8.8.8" teknoradio/icecast /bin/bash
