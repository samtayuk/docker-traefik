FROM alpine:3.5

# Set environment
ENV SERVICE_NAME=traefik \
    SERVICE_HOME=/app/traefik \
    SERVICE_VERSION=v1.2.0-rc2 \
    SERVICE_URL=https://github.com/containous/traefik/releases/download
ENV SERVICE_RELEASE=${SERVICE_URL}/${SERVICE_VERSION}/traefik_linux-amd64 \
    PATH=${PATH}:${SERVICE_HOME}/bin

ADD *.sh $SERVICE_HOME/bin/

# Download and install traefik
RUN mkdir -p ${SERVICE_HOME}/bin ${SERVICE_HOME}/etc ${SERVICE_HOME}/log ${SERVICE_HOME}/certs ${SERVICE_HOME}/acme && \
    apk --no-cache --no-progress add ca-certificates bash && \
    apk --no-cache --no-progress --virtual=.build-dependencies add wget && \
    wget -q "${SERVICE_RELEASE}" -O "${SERVICE_HOME}/bin/traefik" && \
    touch ${SERVICE_HOME}/etc/rules.toml && \
    chmod +x ${SERVICE_HOME}/bin/traefik && \
    chmod +x ${SERVICE_HOME}/bin/*.sh && \
    apk --no-progress del .build-dependencies

EXPOSE 80 443

WORKDIR $SERVICE_HOME

ENTRYPOINT /app/traefik/bin/entrypoint.sh

CMD ["traefik", "--configfile=/app/traefik/etc/traefik.toml"]
