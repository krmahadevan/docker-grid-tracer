#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echo "Starting Selenium Grid EventBus..."

if [ ! -z "$SE_EVENT_BUS_HOST" ]; then
  echo "Using SE_EVENT_BUS_HOST: ${SE_EVENT_BUS_HOST}"
  HOST_CONFIG="--host ${SE_EVENT_BUS_HOST}"
fi

if [ ! -z "$SE_EVENT_BUS_PORT" ]; then
  echo "Using SE_EVENT_BUS_PORT: ${SE_EVENT_BUS_PORT}"
  PORT_CONFIG="--port ${SE_EVENT_BUS_PORT}"
fi

if [ ! -z "$SE_OPTS" ]; then
  echo "Appending Selenium options: ${SE_OPTS}"
fi

curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /tmp/cs
chmod +x /tmp/cs

java ${JAVA_OPTS:-$SE_JAVA_OPTS} -Dwebdriver.http.factory=jdk-http-client \
  -jar /opt/selenium/selenium-server.jar \
  --ext /opt/selenium/selenium-http-jdk-client.jar:$(/tmp/cs fetch --classpath --cache /tmp io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2) event-bus \
  --bind-host ${SE_BIND_HOST} \
  ${HOST_CONFIG} \
  ${PORT_CONFIG} \
  ${SE_OPTS}