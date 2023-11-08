FROM node:lts-bookworm as node
WORKDIR /app

# Clone desktop source
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-desktop.git

# Setup Desktop
RUN npm install -g @angular/cli
WORKDIR /app/receipt-wrangler-desktop

# Set up npmrc
COPY . . 

RUN npm install
RUN npm run build

# Setup API
FROM golang:1.20.7-bullseye

# Clone api soruce
WORKDIR /app
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-api.git

# Setup API
WORKDIR /app/receipt-wrangler-api

# Set up config volume
VOLUME /app/receipt-wrangler-api/config

# Add local bin to path for python dependencies
ENV PATH="~/.local/bin:${PATH}"

# Set env
ENV ENV="prod"

# Set base path
ENV BASE_PATH="/app/receipt-wrangler-api"

# Install tesseract dependencies
RUN ./set-up-dependencies.sh

# Build api
RUN go build

# Set up data volume
RUN mkdir data
VOLUME /app/receipt-wrangler-api/data

# Set up temp directory
RUN mkdir temp

# Set up sqlite volume
VOLUME /app/receipt-wrangler-api/sqlite

# Add logs volume
RUN mkdir logs
VOLUME /app/receipt-wrangler-api/logs

# Setup nginx
WORKDIR /app/receipt-wrangler-monolith
COPY . .
COPY ./entrypoint.sh /app

# Install nginx
RUN apt update
RUN apt install nginx -y

# Remove default configs
RUN rm /etc/nginx/sites-enabled/*
RUN rm /etc/nginx/sites-available/*
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Copy desktop dist
COPY --from=node /app/receipt-wrangler-desktop/dist/receipt-wrangler /usr/share/nginx/html

# Clean up
WORKDIR /app
RUN rm -rf /app/receipt-wrangler-monolith

# Set up entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Expose http port
EXPOSE 80
