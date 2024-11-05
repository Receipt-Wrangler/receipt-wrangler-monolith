FROM golang:1.23.2-bookworm

# First install curl if not already installed
RUN apt-get update
RUN apt-get install -y curl

# Setup NodeSource repository for the LTS version
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

# Install Node.js
RUN apt-get install -y nodejs

# Start in app dir
WORKDIR /app

# Clone desktop
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-desktop.git

# Setup Desktop
RUN ls
WORKDIR /app/receipt-wrangler-desktop
RUN npm install -g @angular/cli

# Build desktop
RUN npm install
RUN npm run build

# Clone api soruce
WORKDIR /app
RUN git clone https://github.com/Receipt-Wrangler/receipt-wrangler-api.git

# Setup API
WORKDIR /app/receipt-wrangler-api

# Add local bin to path for python dependencies
ENV PATH="~/.local/bin:${PATH}"

# Set env
ENV ENV="dev"

# Set base path
ENV BASE_PATH="/app/receipt-wrangler-api"

# Install tesseract dependencies
RUN bash set-up-dependencies.sh

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

# Set pythonpath
ENV PYTHONPATH="/app/receipt-wrangler-api/wranglervenv/lib/python3.11/site-packages"

# Set up entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Expose http port
EXPOSE 80

# Expose SSH
EXPOSE 22

# Keep er runnin
CMD ["tail", "-f", "/dev/null"]
