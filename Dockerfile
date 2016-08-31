FROM benyoo/alpine:3.4.20160812

MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

ENV TERM=linux \
	DATA_DIR=/data/shadowsocks

RUN set -x && \
	apk --update --no-cache upgrade && \
	apk --update --no-cache add python git iproute2 && \
	curl -Lk https://bootstrap.pypa.io/get-pip.py | python && \
	pip install cymysql && \
	[ ! -d $(dirname ${DATA_DIR}) ] && mkdir -p $(dirname ${DATA_DIR}) && cd $(dirname ${DATA_DIR}) && \
	git clone -b manyuser https://github.com/breakwa11/shadowsocks.git && \
	#cd shadowsocks && \
	#cp config.json user-config.json && \
	rm -rf /var/cache/apk/* ~/.cache


WORKDIR ${DATA_DIR}
VOLUME [${DATA_DIR}]
EXPOSE 10000-10020
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
