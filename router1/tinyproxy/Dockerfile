# Use a base image
FROM alpine:latest

# Update the image with the latest packages (recommended) 
RUN apk update
RUN apk add tinyproxy

WORKDIR /etc/tinyproxy
# Set the default command to run tinyproxy
CMD ["tinyproxy", "-d", "-c", "tinyproxy.conf"]

LABEL description="Docker image for running tinyproxy"
 
# Expose the default port used by tinyproxy
EXPOSE 3128
