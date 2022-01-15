ARG BASE
ARG PCNG_TAG

FROM ${BASE} AS src
ARG PROXY
ENV HTTP_PROXY=$PROXY
ENV HTTPS_PROXY=$PROXY
RUN apt-get update && apt-get install git -y
RUN mkdir /src && cd /src && \
    git clone https://github.com/rofl0r/proxychains-ng
RUN cd /src/proxychains-ng && git checkout ${PCNG_TAG}

FROM ${BASE} AS build
ARG PROXY
ENV HTTP_PROXY=$PROXY
ENV HTTPS_PROXY=$PROXY
COPY --from=src /src /src
RUN apt-get update && apt-get install build-essential -y
WORKDIR /src/proxychains-ng 
RUN ./configure --prefix=/opt/pcng
RUN sed -i 's/\/bin//;  s/\/lib//; s/\/etc//' config.mak && cat config.mak
RUN make && make install && make install-config
RUN sed -i 's/socks4 	127.0.0.1 9050/socks5 127.0.0.1 1081/' /opt/pcng/proxychains.conf
RUN chmod +x /opt/pcng/proxychains4
RUN cat /opt/pcng/proxychains.conf
RUN printf "#!/bin/bash\n[ ! -z \${USE_PROXY} ] && exec /opt/pcng/proxychains4 \"\$@\" || exec \"\$@\"" > /opt/pcng/pcng \
    && chmod +x /opt/pcng/pcng

FROM ${BASE} AS release
COPY --from=build /opt/pcng/ /opt/pcng/
