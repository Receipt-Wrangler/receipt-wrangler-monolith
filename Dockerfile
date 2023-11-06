FROM node:21-bookworm
WORKDIR /app

# Apt update
RUN apt update

# Pull clone source
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-api.git
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-desktop.git

# Install GO
RUN wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN go version

# Setup API
WORKDIR /app/receipt-wrangler-api

# Set up config volume
VOLUME /go/api/config

## Add local bin to path for python dependencies
ENV PATH="~/.local/bin:${PATH}"

## Set env
ENV ENV="prod"

## Set base path
ENV BASE_PATH="/go/api"

## Install tesseract dependencies
RUN ./set-up-dependencies.sh

## Build api
RUN go build

## Set up data volume
RUN mkdir data
VOLUME /go/api/data

## Set up temp directory
RUN mkdir temp

## Set up sqlite volume
VOLUME /go/api/sqlite

## Add logs volume
RUN mkdir logs
VOLUME /go/api/logs

# Setup Desktop
RUN npm install -g @angular/cli
WORKDIR /app/receipt-wrangler-desktop
RUN npm install
RUN npm run build

# Setup nginx
RUN apt update
RUN apt install nginx -y
WORKDIR /app/receipt-wrangler-monolith
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Copy desktop dist
WORKDIR /app/receipt-wrangler-desktop
COPY ./dist/receipt-wrangler /usr/share/nginx/html

EXPOSE 80
