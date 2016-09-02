FROM benyoo/alpine:3.4.20160812

MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

ENV TERM=linux \
	DATA_DIR=/data/shadowsocks

RUN set -x && \
	apk --update --no-cache upgrade && \
	apk --update --no-cache add python git iproute2 build-base tar && \
	mkdir /tmp/libsodium && \
	curl -Lk https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz|tar xz -C /tmp/libsodium --strip-components=1 && \
	cd /tmp/libsodium && \
	./configure && \
	make -j $(awk '/processor/{i++}END{print i}' /proc/cpuinfo) && \
	make install && \
	#ldconfig && \
	curl -Lk https://bootstrap.pypa.io/get-pip.py | python && \
	pip install cymysql && \
	[ ! -d $(dirname ${DATA_DIR}) ] && mkdir -p $(dirname ${DATA_DIR}) && cd $(dirname ${DATA_DIR}) && \
	git clone -b manyuser https://github.com/breakwa11/shadowsocks.git && \
	#cd shadowsocks && \
	#cp config.json user-config.json && \
	apk --no-cache del build-base && \
	rm -rf /var/cache/apk/* ~/.cache /tmp/libsodium


WORKDIR ${DATA_DIR}
VOLUME [${DATA_DIR}]
EXPOSE 10000-10020
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
