#!/bin/sh

# Install curl and jq
apk --no-cache add curl jq

# Wait for Elasticsearch to be available
until $(curl --output /dev/null --silent --head --fail http://elasticsearch:9200); do
    printf '.'
    sleep 5
done

# Get the ID of the existing index pattern named "nsg-flow-logs-*"
INDEX_PATTERN_ID=$(curl -s -X GET "http://elasticsearch:9200/.kibana/_search?q=index-pattern.title:nsg-flow-logs-*" \
  -H 'Content-Type: application/json' | jq -r '.hits.hits[0]?._id')

# Delete the existing index pattern if it exists
if [ ! -z "$INDEX_PATTERN_ID" ]; then
  curl -X DELETE "http://elasticsearch:9200/.kibana/_doc/$INDEX_PATTERN_ID" \
    -H 'Content-Type: application/json'
  echo "Deleted old index pattern: nsg-flow-logs-*"
fi

# Create a new index pattern
curl -X POST "http://elasticsearch:9200/.kibana/_doc/index-pattern:nsg-flow-logs-*" \
  -H 'Content-Type: application/json' \
  -d '{
        "type": "index-pattern",
        "index-pattern": {
          "title": "nsg-flow-logs-*",
          "timeFieldName": "time"
        }
      }'

echo "Elasticsearch setup completed."
