#!/bin/bash

# Start nginx
nginx -g 'daemon off;'

# Start api
cd /app/receipt-wrangler-api
./api --env prod
