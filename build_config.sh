#!/bin/bash
set -eu
. ../config.cfg

FABIO_LIST=$(echo $SRY_MASTER_LIST |sed "s/,/ /g")
FABIO_SERVERS=""

for fobio in $FABIO_LIST;do
    FABIO_SERVERS+="        server sry-fabio-$fobio:9999 $fobio:9999 check inter 5000  maxconn 10\n"
done

replace_var(){
    files=$@
    echo $files | xargs sed -i 's#--MYSQL_MASTER_HOST--#'$SRY_MYSQL_MASTER_HOST'#g'
    echo $files | xargs sed -i 's#--MYSQL_SLAVE_HOST--#'$SRY_MYSQL_SLAVE_HOST'#g'
    echo $files | xargs sed -i 's/--FABIO_SERVERS--/'"$FABIO_SERVERS"'/g'
}

pre_conf(){
    rm -f docker-compose.yml
    cp docker-compose.yml.temp docker-compose.yml
    files="docker-compose.yml"
    replace_var $files
}


prehaproxy_conf(){
    rm -rf
    cp -rf conf.temp conf_tmp

    files=`grep -rl '' conf_tmp/*`
    replace_var $files

    rm -rf conf
    mv conf_tmp conf
}

prehaproxy_conf
