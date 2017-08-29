#!/bin/bash

CONNECT_HOST=localhost

if [[ $1 ]];then
    CONNECT_HOST=$1
fi

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "wikipedia-irc",
  "config": {
    "connector.class": "com.github.cjmatta.kafka.connect.irc.IrcSourceConnector",
    "transforms": "WikiEditTransformation",
    "transforms.WikiEditTransformation.type": "com.github.cjmatta.kafka.connect.transform.wikiedit.WikiEditTransformation",
    "transforms.wikiEditTransformation.save.unparseable.messages": true,
    "transforms.wikiEditTransformation.dead.letter.topic": "wikipedia.failed",
    "irc.channels": "#en.wikipedia,#fr.wikipedia,#es.wikipedia,#ru.wikipedia,#en.wiktionary,#de.wikipedia,#zh.wikipedia",
    "irc.server": "irc.wikimedia.org",
    "kafka.topic": "wikipedia.parsed",
    "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
    "tasks.max": "1"
  }
}
EOF
)

echo "curl -X POST -H \"${HEADER}\" --data \"${DATA}\" http://${CONNECT_HOST}:8083/connectors"
curl -X POST -H "${HEADER}" --data "${DATA}" http://${CONNECT_HOST}:8083/connectors
echo
