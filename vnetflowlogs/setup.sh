#!/bin/sh

# Install curl and jq
apk --no-cache add curl jq

# Wait for Elasticsearch to be available
until $(curl --output /dev/null --silent --head --fail http://elasticsearch:9200); do
    printf '.'
    sleep 5
done

# Get the ID of the existing index pattern named "vnet-flow-logs"
response=$(curl -o /dev/null -s -w "%{http_code}" -I "http://localhost:9200/vnet-flow-logs")

# If the response is 200, the index exists
if [ "$response" -eq 200 ]; then
  echo "Index exists. Deleting now..."
  curl -X DELETE "http://localhost:9200/vnet-flow-logs"
else
  echo "Index does not exist."
fi

# Create a new index pattern
curl -X POST "http://elasticsearch:9200/.kibana/_doc/index-pattern:vnet-flow-logs" \
  -H 'Content-Type: application/json' \
  -d '{
        "type": "index-pattern",
        "index-pattern": {
          "title": "vnet-flow-logs",
          "timeFieldName": "time"
        }
      }'

echo "Elasticsearch setup completed."
