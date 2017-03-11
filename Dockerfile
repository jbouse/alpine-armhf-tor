FROM    jtbouse/alpine-armhf

MAINTAINER Jeremy T. Bouse <Jeremy.Bouse@UnderGrid.net>

ENV     HOME /var/lib/tor

ADD     assets/entrypoint-config.yml /
ADD     assets/onions /usr/local/src/onions
ADD     assets/torrc /var/local/tor/torrc.tpl

RUN	["docker-build-start"]
RUN	apk add --no-cache tor openssl python3 \
	&& apk add --no-cache --virtual .build-deps \
		git libevent-dev openssl-dev gcc make \
		automake autoconf musl-dev coreutils python3-dev \
        && python3 -m ensurepip \
        && rm -r /usr/lib/python*/ensurepip \
        && pip3 install --upgrade pip setuptools pycrypto \
        && apk del .build-deps \ 
	&& pip install pyentrypoint==0.5.0 \
	&& cd /usr/local/src/onions \
	&& python3 setup.py install
RUN	["docker-build-end"]

VOLUME  ["/var/lib/tor/hidden_service/"]

ENTRYPOINT ["pyentrypoint"]

CMD     ["tor"]
