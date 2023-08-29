#!/bin/bash

# set write permissions
echo "====set lua.log write permissions===="
chmod a+rw /usr/local/openresty/nginx/logs/lua.log
chmod a+rw /usr/local/openresty/nginx/conf/nginx.conf
chmod a+rw /tmp/init.sh

# install module
echo "====luarocks install lua-resty-http===="
luarocks install lua-resty-http
echo "====Install lua-resty-http success!===="
echo "====Start openresty===="
/usr/local/openresty/bin/openresty -g "daemon off;"
