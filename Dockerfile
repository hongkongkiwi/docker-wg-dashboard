FROM node:10.18.1-alpine3.9

RUN apk --no-cache --update --virtual build-dependencies add \
      build-base python python3 tzdata && \
    apk --no-cache --update add \
      curl git ca-certificates openssl && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
      wireguard-tools && \
    git clone https://github.com/wg-dashboard/wg-dashboard.git /wg-dashboard && \
    cd "/wg-dashboard" && \
    npm install . && \
    curl -L -o /tmp/coredns-latest.tgz \
    "$(curl -Ls https://api.github.com/repos/coredns/coredns/releases | \
      awk '/browser_download_url/ {print $2}' | sort -ru | \
      awk '/linux_amd64.tgz"/ {print; exit}' | sed -r 's/"(.*)"/\1/')" && \
    tar -C /usr/bin -xvzf /tmp/coredns-latest.tgz && \
    adduser -h /config -S coredns && \
    rm /tmp/coredns-latest.tgz && \
    apk del build-dependencies

ENV TZ=Asia/Hong_Kong

EXPOSE 3000
EXPOSE 53

WORKDIR "/wg-dashboard"

ENTRYPOINT ["/usr/local/bin/npm"]
CMD ["run", "server"]
