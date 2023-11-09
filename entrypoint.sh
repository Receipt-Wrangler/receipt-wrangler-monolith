#!/bin/bash

# Start api
cd /app/receipt-wrangler-api
./api --env prod &

# Start nginx
nginx -g 'daemon off;'

