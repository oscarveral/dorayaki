# Use a base image
FROM alpine:latest
 
# Install required packages
RUN apk update && \
    apk add --no-cache tinyproxy

WORKDIR /etc/tinyproxy
# Set the default command to run tinyproxy
CMD ["tinyproxy", "-d", "-c", "tinyproxy.conf"]
 
# Add labels for better maintainability
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker image for running tinyproxy"
 
# Expose the default port used by tinyproxy
EXPOSE 3128
