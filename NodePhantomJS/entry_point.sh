#!/bin/bash
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

if [ -z "$HUB_PORT_4444_TCP_ADDR" ]; then
  echo Not linked with a running Hub container 1>&2
  exit 1
fi

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

# TODO: Look into http://www.seleniumhq.org/docs/05_selenium_rc.jsp#browser-side-logs

#xvfb-run --server-args="$DISPLAY -screen 0 $GEOMETRY -ac +extension RANDR" \
#  java -jar /opt/selenium/selenium-server-standalone.jar \
#    -role node \
#    -hub http://$HUB_PORT_4444_TCP_ADDR:$HUB_PORT_4444_TCP_PORT/grid/register \
#    -nodeConfig /opt/selenium/config.json &
#NODE_PID=$!

ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

phantomjs --webdriver=$ip:8080 --webdriver-selenium-grid-hub=http://$HUB_PORT_4444_TCP_ADDR:$HUB_PORT_4444_TCP_PORT

trap shutdown SIGTERM SIGINT
wait $NODE_PID
