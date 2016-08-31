#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2016年08月31日 星期三 16时29分36秒
#########################################################################

set -e

[ "${1:0:1}" = '-' ] && set -- python "$@"

if [[ "$MANYUSER" =~ ^[Yy][Ee][Ss]$ ]]; then
	if [ ! -f userapiconfig.py ]; then
		cp apiconfig.py userapiconfig.py
		cp mysql.json usermysql.json
		[ -n "$API_INTERFACE" ] && { [[ "$API_INTERFACE" =~ ^sspanelv(2|3(ssr)?)$ ]] && sed -ri "s/^(API_INTERFACE).*/\1 = '${API_INTERFACE}'/" userapiconfig.py; }
		[ -f user-config.json ] && rm -rf user-config.json
	fi

	if [ -z "$MYSQL_PASSWORD" ]; then
		echo >&2 'error:  missing MYSQL_PASSWORD'
		echo >&2 '  Did you forget to add -e MYSQL_PASSWORD=... ?'
		exit 1
	fi

	if [ -z "$MYSQL_USER" ]; then
		echo >&2 'error:  missing MYSQL_USER'
		echo >&2 '  Did you forget to add -e MYSQL_USER=... ?'
		exit 1
	fi

	MYSQL_PORT=${MYSQL_PORT:-3306}
	#if [ -z "$MYSQL_PORT" ]; then
	#	echo >&2 'error:  missing MYSQL_PORT'
	#	echo >&2 '  Did you forget to add -e MYSQL_PORT=... ?'
	#	exit 1
	#fi

	if [ -z "$MYSQL_HOST" ]; then
		echo >&2 'error:  missing MYSQL_HOST'
		echo >&2 '  Did you forget to add -e MYSQL_HOST=... ?'
		exit 1
	fi

	if [ -z "$MYSQL_DBNAME" ]; then
		echo >&2 'error:  missing MYSQL_DBNAME'
		echo >&2 '  Did you forget to add -e MYSQL_DBNAME=... ?'
		exit 1
	fi

	for i in $MYSQL_USER $MYSQL_PORT $MYSQL_HOST $MYSQL_DBNAME $MYSQL_PASSWORD; do
		if grep '@' <<<"$i" >/dev/null 2>&1; then
			echo >&2 "error:  missing -e $i"
			echo >&2 "  You can't special characters '@'"
			exit 1
		fi
	done

	sed -ri "s@^(MYSQL_HOST = ).*@\1'$MYSQL_HOST'@" usermysql.json
	sed -ri "s@^(MYSQL_PORT = ).*@\1$MYSQL_PORT@" usermysql.json
	sed -ri "s@^(MYSQL_USER = ).*@\1'$MYSQL_USER'@" usermysql.json
	sed -ri "s@^(MYSQL_PASS = ).*@\1'$MYSQL_PASSWORD'@" usermysql.json
	sed -ri "s@^(MYSQL_DB = ).*@\1'$MYSQL_DBNAME'@" usermysql.json
elif [[ "$MANYUSER" =~ ^[Nn][Oo]$ ]]; then
	[ -f userapiconfig.py ] && rm -rf userapiconfig.py
	[ -f usermysql.json ] && rm -rf usermysql.json
	[ ! -f user-config.json ] && cp config.json user-config.json
	[ -n "${SERVER_PORT}" ] && sed -ri "s/(\"server_port\":).*/\1 ${SERVER_PORT},/" user-config.json
	[ -n "${LOCAL_ADDRESS}" ] && sed -ri "s/(\"local_address\":).*/\1 \"${LOCAL_ADDRESS}\",/" user-config.json
	[ -n "${LOCAL_PORT}" ] && sed -ri "s/(\"local_port\":).*/\1 ${LOCAL_PORT},/" user-config.json
	[ -n "${PASSWORD}" ] && sed -ri "s/(\"password\":).*/\1 \"${PASSWORD}\",/" user-config.json
else
	echo >&2 'error:  missing MANYUSER'
	echo >&2 '  Did you forget to add -e MANYUSER=... ?'
	echo >&2 "  Variable MANYUSER accept only yes and no assignment."
	exit 1
fi

if [ "$MANYUSER" = "R" ]; then
	if [ -z "$PROTOCOL" ]; then
		echo >&2 'error:  missing PROTOCOL'
		echo >&2 '  Did you forget to add -e PROTOCOL=... ?'
		exit 1
	elif [[ ! "$PROTOCOL" =~ ^(origin|verify_simple|verify_deflate|auth_simple)$ ]]; then
		echo >&2 'error : missing PROTOCOL'
		echo >&2 '  You must be used -e PROTOCOL=[origin|verify_simple|verify_deflate|auth_simple]'
		exit 1
	fi

	if [ -z "$OBFS" ]; then
		echo >&2 'error:  missing OBFS'
		echo >&2 '  Did you forget to add -e OBFS=... ?'
		exit 1
	elif [[ ! "$OBFS" =~ ^(plain|http_simple|http_simple_compatible|tls_simple|tls_simple_compatible|random_head|random_head_compatible)$ ]]; then
		echo >&2 'error:  missing OBFS'
		echo >&2 '  You must be used -e OBFS=[plain|http_simple|http_simple_compatible|tls_simple|tls_simple_compatible|random_head|random_head_compatible]'
		exit 1
	fi

	if [ -z "$OBFS_PARAM" ]; then
		echo >&2 'error:  missing OBFS_PARAM'
		echo >&2 '  Did you forget to add -e OBFS_PARAM=... ?'
		exit 1
	fi

	if [ -n "$METHOD" ]; then
		if [[ ! "$METHOD" =~ ^(aes-(256|192|128)-cfb|(chacha|salsa)20|rc4-md5)$ ]]; then
			echo >&2 'error:  missing METHOD'
			echo >&2 '  You must be used -e METHOD=[aes-256-cfb|aes-192-cfb|aes-128-cfb|chacha20|salsa20|rc4-md5]'
			exit 1
		else
			sed -ri "s@^(.*\"method\": ).*@\1\"$METHOD\",@" /shadowsocks/config.json
		fi
	fi

	if [ -n "$DNS_IPV6" ]; then
		if [[ ! "$DNS_IPV6" =~ ^(false|true)$ ]]; then
			echo >&2 'error:  missing DNS_IPV6'
			echo >&2 '  You must be used -e DNS_IPV6=[false|true]'
			exit 1
		else
			sed -ri "s@^(.*\"dns_ipv6\": ).*@\1\"$DNS_IPV6\",@" /shadowsocks/config.json
		fi
	fi

	sed -ri "s@^(.*\"protocol\": ).*@\1\"$PROTOCOL\",@" /shadowsocks/config.json
	sed -ri "s@^(.*\"obfs\": ).*@\1\"$OBFS\",@" /shadowsocks/config.json
	sed -ri "s@^(.*\"obfs_param\": ).*@\1\"$OBFS_PARAM\",@" /shadowsocks/config.json
fi

exec python ${DATA_DIR}/shadowsocks/server.py
