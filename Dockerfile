# Base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install common dependencies (this layer will be cached if the list of packages remains unchanged)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up environment variables (cached separately)
ENV MY_APP_ENV=production
ENV MY_APP_VERSION=1.0.0

# Add source files (this layer invalidates only if files change)
WORKDIR /app
COPY . .

# Run a placeholder command (replace with the actual commands if needed)
RUN echo "Building application..." && sleep 1
