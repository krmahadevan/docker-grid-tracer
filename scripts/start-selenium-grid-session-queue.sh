#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echo "Starting Selenium Grid SessionQueue..."

if [ ! -z "$SE_OPTS" ]; then
  echo "Appending Selenium options: ${SE_OPTS}"
fi

if [ ! -z "$SE_SESSION_QUEUE_HOST" ]; then
  echo "Using SE_SESSION_QUEUE_HOST: ${SE_SESSION_QUEUE_HOST}"
  HOST_CONFIG="--host ${SE_SESSION_QUEUE_HOST}"
fi

if [ ! -z "$SE_SESSION_QUEUE_PORT" ]; then
  echo "Using SE_SESSION_QUEUE_PORT: ${SE_SESSION_QUEUE_PORT}"
  PORT_CONFIG="--port ${SE_SESSION_QUEUE_PORT}"
fi

curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /tmp/cs
chmod +x /tmp/cs

java ${JAVA_OPTS:-$SE_JAVA_OPTS} -Dwebdriver.http.factory=jdk-http-client \
  -jar /opt/selenium/selenium-server.jar \
  --ext /opt/selenium/selenium-http-jdk-client.jar:$(/tmp/cs fetch --classpath --cache /tmp io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2) sessionqueue \
  --session-request-timeout ${SE_SESSION_REQUEST_TIMEOUT} \
  --session-retry-interval ${SE_SESSION_RETRY_INTERVAL} \
  --bind-host ${SE_BIND_HOST} \
  ${HOST_CONFIG} \
  ${PORT_CONFIG} \
  ${SE_OPTS}
