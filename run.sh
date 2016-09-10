#/bin/bash
set -e
BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg
./build_config.sh
docker-compose -p offline up -d
