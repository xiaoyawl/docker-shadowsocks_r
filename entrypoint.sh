#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2016年09月02日 星期五 17时51分49秒
#########################################################################

set -e
[ "${1:0:1}" = '-' ] && set -- python "$@"

API_INTERFACE=${API_INTERFACE:-mudbjson}
SERVER=${SERVER:-0.0.0.0}                             #"server": "0.0.0.0",
SERVER_IPV6=${SERVER_IPV6:-::}                        #"server_ipv6": "::",
SERVER_PORT=${SERVER_PORT:-8388}                      #"server_port": 8388,
LOCAL_ADDRESS=${LOCAL_ADDRESS:-127.0.0.1}             #"local_address": "127.0.0.1",
LOCAL_PORT=${LOCAL_PORT:-1080}                        #"local_port": 1080,
PASSWORD=${PASSWORD:-m}                               #"password": "m",
TIMEOUT=${TIMEOUT:-120}                               #"timeout": 120,
UDP_TIMEOUT=${UDP_TIMEOUT:-60}                        #"udp_timeout": 60,
METHOD=${METHOD:-aes-256-cfb}                         #"method": "aes-256-cfb",
PROTOCOL=${PROTOCOL:-auth_sha1_compatible}            #"protocol": "auth_sha1_compatible",
PROTOCOL_PARAM=${PROTOCOL_PARAM}                      #"protocol_param": "",
OBFS=${OBFS:-http_simple_compatible}                  #"obfs": "http_simple_compatible",
OBFS_PARAM=${OBFS_PARAM}                              #"obfs_param": "",
DNS_IPV6=${DNS_IPV6:-false}                           #"dns_ipv6": false,
CONNECT_VERBOSE_INFO=${CONNECT_VERBOSE_INFO:-0}       #"connect_verbose_info": 0,
REDIRECT=${REDIRECT}                                  #"redirect": "",
FAST_OPEN=${FAST_OPEN:-false}                         #"fast_open": false

if [ -z ${MANYUSER} ]; then
	echo >&2 'error:  missing MANYUSER'
	echo >&2 ' Did you forget to add -e MANYUSER=... ?'
	echo >&2 ' You can add -e MANYUSER=[Yes|No], If you add -e MANYUSER=Yes, You must to be add -e SSR_SQL=Yes or SSR_JSON=Yes.'
	exit 1
fi

if [[ "$MANYUSER" =~ ^[Yy][Ee][Ss]$ ]]; then
	if [[ "$SSR_SQL" =~ ^[Yy][Ee][Ss]$ ]]; then
		echo "Beta"
	elif [[ "$SSR_JSON" =~ ^[Yy][Ee][Ss]$ ]]; then
		[ ! -f userapiconfig.py ] && cp apiconfig.py userapiconfig.py || cat apiconfig.py > userapiconfig.py
		sed -ri "s/^(API_INTERFACE =).*/\1 '${API_INTERFACE}'/" userapiconfig.py
		#method:aes-128-cfb aes-192-cfb aes-256-cfb rc4-md5 rc4-md5-6 chacha20 chacha20-ietf salsa20 bf-cfb camellia-128-cfb camellia-192-cfb camellia-256-cfb aes-128-ctr aes-192-ctr aes-256-ctr
		#^((aes|camellia)-(128|192|256)-(cfb|ctr)|bf-cfb|rc4-md5(-6)?|chacha20(-ietf)?)$
		#^(aes-(128|192|256)-cfb|rc4-md5(-6)?|chacha20(-ietf)?|bf-cfb|camellia-(128|192|256)-cfb|aes-(128|192|256)-ctr)$
		#protocol: origin verify_sha1_compatible verify_sha1 auth_sha1_compatible auth_sha1 auth_sha1_v2_compatible auth_sha1_v2 auth_sha1_v3_compatible auth_sha1_v3
		#obfs: plain http_simple_compatible  http_simple tls1.2_ticket_auth_compatible tls1.2_ticket_auth
	else
		echo >&2 'error:  missing MANYUSER'
		echo >&2 ' If you add -e MANYUSER=Yes, Maybe you forgot to add -e SSR_SQL=Yes or SSR_JSON=Yes .'
		exit 1
	fi
elif [[ "$MANYUSER" =~ ^[No][Oo]$ ]]; then
	[ ! -f user-config.json ] && cat config.json > user-config.json
	[ -f userapiconfig.py ] && rm -rf userapiconfig.py
	[ -f usermysql.json ] && rm -rf usermysql.json
	sed -ri "s/(\"server\":).*/\1 \"${SERVER}\",/" user-config.json
	sed -ri "s/(\"server_ipv6\":).*/\1 \"${SERVER_IPV6}\",/" user-config.json
	sed -ri "s/(\"server_port\":).*/\1 ${SERVER_PORT},/" user-config.json
	sed -ri "s/(\"local_address\":).*/\1 \"${LOCAL_ADDRESS}\",/" user-config.json
	sed -ri "s/(\"local_port\":).*/\1 ${LOCAL_PORT},/" user-config.json
	sed -ri "s/(\"password\":).*/\1 \"${PASSWORD}\",/" user-config.json
	sed -ri "s/(\"timeout\":).*/\1 \"${TIMEOUT}\",/" user-config.json
	sed -ri "s/(\"udp_timeout\":).*/\1 \"${UDP_TIMEOUT}\",/" user-config.json
	sed -ri "s/(\"method\":).*/\1 \"${METHOD}\",/" user-config.json
	sed -ri "s/(\"protocol\":).*/\1 \"${PROTOCOL}\",/" user-config.json
	sed -ri "s/(\"protocol_param\":).*/\1 \"${PROTOCOL_PARAM}\",/" user-config.json
	sed -ri "s/(\"obfs\":).*/\1 \"${OBFS}\",/" user-config.json
	sed -ri "s/(\"obfs_param\":).*/\1 \"${OBFS_PARAM}\",/" user-config.json
	sed -ri "s/(\"dns_ipv6\":).*/\1 \"${DNS_IPV6}\",/" user-config.json
	sed -ri "s/(\"connect_verbose_info\":).*/\1 \"${CONNECT_VERBOSE_INFO}\",/" user-config.json
	sed -ri "s/(\"redirect\":).*/\1 \"${REDIRECT}\",/" user-config.json
	sed -ri "s/(\"fast_open\":).*/\1 \"${FAST_OPEN}\"/" user-config.json
fi

exec "${@}" ${DATA_DIR}/shadowsocks/server.py
