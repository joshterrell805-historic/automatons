#!/bin/bash
. ".env"
mysql -u $mysql_user -p"$mysql_password" -h $mysql_host --database $mysql_database "$@"
