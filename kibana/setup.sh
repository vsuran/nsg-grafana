#!/bin/sh

# Install curl
apk update
apk --no-cache add curl jq

# Wait for Kibana to be available
until $(curl --output /dev/null --silent --head --fail http://kibana:5601); do
    printf '.'
    sleep 5
done

# # Get the ID of the existing index pattern named "nsg-flow-logs"
INDEX_PATTERN_ID=$(curl -s -X GET "http://kibana:5601/api/saved_objects/_find?type=index-pattern&search=nsg-flow-logs&search_fields=title" \
  -H 'kbn-xsrf: true' | jq -r '.saved_objects[].id')

# Delete the existing index pattern if it exists
if [ ! -z "$INDEX_PATTERN_ID" ]; then
  curl -X DELETE "http://kibana:5601/api/saved_objects/index-pattern/$INDEX_PATTERN_ID" \
    -H 'kbn-xsrf: true'
  echo "Deleted old index pattern: nsg-flow-logs"
fi

# Create index pattern
curl -X POST "http://kibana:5601/api/saved_objects/index-pattern" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d '{
        "attributes": {
          "title": "nsg-flow-logs",
          "timeFieldName": "time"
        }
      }'

# Set the default index pattern
curl -X POST "http://kibana:5601/api/kibana/settings/defaultIndex" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d '{
        "value": "nsg-flow-logs"
      }'

echo "Kibana setup completed."