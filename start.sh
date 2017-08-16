#!/bin/bash -x
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

docker run -i                        \
    --detach=false                   \
    --tty=true                       \
    --rm                             \
    --dns "8.8.8.8"                  \
    --volume "$DIR/data":/data       \
    --volume "$DIR/logging":/logging \
    --entrypoint /bin/bash           \
teknoradio/base /bin/bash

