FROM node:10.18.1-alpine3.9

#ADD ./config/coredns /etc/coredns/Corefile
COPY ./scripts/* /usr/local/bin/

RUN apk --no-cache --update --virtual build-dependencies add \
      build-base python python3 tzdata && \
    apk --no-cache --update add \
      curl git ca-certificates openssl nano sudo && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
      wireguard-tools && \
    git clone https://github.com/wg-dashboard/wg-dashboard.git /wg-dashboard && \
    cd "/wg-dashboard" && \
    npm install --production . && \
    curl -L -o /tmp/coredns-latest.tgz \
    "$(curl -Ls https://api.github.com/repos/coredns/coredns/releases | \
      awk '/browser_download_url/ {print $2}' | sort -ru | \
      awk '/linux_amd64.tgz"/ {print; exit}' | sed -r 's/"(.*)"/\1/')" && \
    tar -C /usr/bin -xvzf /tmp/coredns-latest.tgz && \
    rm /tmp/coredns-latest.tgz && \
    apk del build-dependencies && \
    mkdir -p /etc/coredns

VOLUME ["/configs"]

RUN mkdir -p "/etc/wireguard" && \
    mkdir -p "/etc/coredns" && \
    touch "/configs/server_config.json" && \
    ln -s "/configs/server_config.json" "/wg-dashboard/server_config.json" && \
    touch "/configs/Corefile" && \
    ln -s "/configs/Corefile" "/etc/coredns/Corefile" && \
    addgroup -g 1001 -S docker && \
    adduser -u 1001 -S docker -G docker && \
    adduser -h /config -S coredns -G docker && \
    chown -R docker:docker /wg-dashboard && \
    chown docker:docker /usr/bin/coredns && \
    chmod +x /usr/local/bin/* && \
    chown docker:docker /usr/local/bin/*

USER root

ENV TZ=Asia/Hong_Kong

EXPOSE 3000
EXPOSE 53

WORKDIR "/wg-dashboard"

CMD ["/usr/local/bin/start.sh"]
