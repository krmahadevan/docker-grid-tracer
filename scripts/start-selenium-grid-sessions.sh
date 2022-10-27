#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

echo "Starting Selenium Grid Sessions..."

if [[ -z "${SE_EVENT_BUS_HOST}" ]]; then
  echo "SE_EVENT_BUS_HOST not set, exiting!" 1>&2
  exit 1
fi

if [[ -z "${SE_EVENT_BUS_PUBLISH_PORT}" ]]; then
  echo "SE_EVENT_BUS_PUBLISH_PORT not set, exiting!" 1>&2
  exit 1
fi

if [[ -z "${SE_EVENT_BUS_SUBSCRIBE_PORT}" ]]; then
  echo "SE_EVENT_BUS_SUBSCRIBE_PORT not set, exiting!" 1>&2
  exit 1
fi

if [ ! -z "$SE_OPTS" ]; then
  echo "Appending Selenium options: ${SE_OPTS}"
fi

if [ ! -z "$SE_SESSIONS_HOST" ]; then
  echo "Using SE_SESSIONS_HOST: ${SE_SESSIONS_HOST}"
  HOST_CONFIG="--host ${SE_SESSIONS_HOST}"
fi

if [ ! -z "$SE_SESSIONS_PORT" ]; then
  echo "Using SE_SESSIONS_PORT: ${SE_SESSIONS_PORT}"
  PORT_CONFIG="--port ${SE_SESSIONS_PORT}"
fi

curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /tmp/cs
chmod +x /tmp/cs

java ${JAVA_OPTS:-$SE_JAVA_OPTS} -Dwebdriver.http.factory=jdk-http-client \
  -jar /opt/selenium/selenium-server.jar \
  --ext /opt/selenium/selenium-http-jdk-client.jar:$(/tmp/cs fetch --classpath --cache /tmp io.opentelemetry:opentelemetry-exporter-jaeger:1.19.0 io.grpc:grpc-netty:1.50.2)  sessions \
  --publish-events tcp://"${SE_EVENT_BUS_HOST}":${SE_EVENT_BUS_PUBLISH_PORT} \
  --subscribe-events tcp://"${SE_EVENT_BUS_HOST}":${SE_EVENT_BUS_SUBSCRIBE_PORT} \
  --bind-host ${SE_BIND_HOST} \
  ${HOST_CONFIG} \
  ${PORT_CONFIG} \
  ${SE_OPTS}
