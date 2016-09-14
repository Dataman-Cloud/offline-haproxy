#!/bin/bash
set -exu

if [ -f "../config.cfg" ];then
	. ../config.cfg
else 
	. ./config.cfg
fi

FABIO_LIST=$(echo $SRY_MASTER_LIST |sed "s/,/ /g")
FABIO_SERVERS=""

for fobio in $FABIO_LIST;do
    FABIO_SERVERS+="        server sry-fabio-$fobio:9999 $fobio:9999 check inter 5000  maxconn 10\n"
done

MYSQL_SERVERS="        server sry-mysqlmaster-3306 $SRY_MYSQL_MASTER_HOST:3306 check inter 5000 on-marked-up shutdown-backup-sessions\n        server sry-mysqlslave-3306 $SRY_MYSQL_SLAVE_HOST:3306 check inter 5000 backup\n"

replace_var(){
    files=$@
    echo $files | xargs sed -i 's/--FABIO_SERVERS--/'"$FABIO_SERVERS"'/g'
    echo $files | xargs sed -i 's/--MYSQL_SERVERS--/'"$MYSQL_SERVERS"'/g'
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
