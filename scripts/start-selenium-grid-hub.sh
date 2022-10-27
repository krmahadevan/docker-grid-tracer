#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

if [ ! -z "$SE_OPTS" ]; then
  echo "Appending Selenium options: ${SE_OPTS}"
fi

if [ ! -z "$SE_HUB_HOST" ]; then
  echo "Using SE_HUB_HOST: ${SE_HUB_HOST}"
  HOST_CONFIG="--host ${SE_HUB_HOST}"
fi

if [ ! -z "$SE_HUB_PORT" ]; then
  echo "Using SE_HUB_PORT: ${SE_HUB_PORT}"
  PORT_CONFIG="--port ${SE_HUB_PORT}"
fi

curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /tmp/cs
chmod +x /tmp/cs

java ${JAVA_OPTS:-$SE_JAVA_OPTS} -Dwebdriver.http.factory=jdk-http-client \
  -jar /opt/selenium/selenium-server.jar \
  --ext /opt/selenium/selenium-http-jdk-client.jar:$(/tmp/cs fetch --classpath --cache /tmp io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2) hub \
  --session-request-timeout ${SE_SESSION_REQUEST_TIMEOUT} \
  --session-retry-interval ${SE_SESSION_RETRY_INTERVAL} \
  --relax-checks ${SE_RELAX_CHECKS} \
  --bind-host ${SE_BIND_HOST} \
  ${HOST_CONFIG} \
  ${PORT_CONFIG} \
  ${SE_OPTS}
