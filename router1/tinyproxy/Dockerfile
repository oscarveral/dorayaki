# Use a base image
FROM fedora:latest
 
# Update the image with the latest packages (recommended) 
RUN yum update -y; yum clean all

# Install Apache Web Server 
RUN yum install -y tinyproxy; yum clean all

WORKDIR /etc/tinyproxy
# Set the default command to run tinyproxy
CMD ["tinyproxy", "-d", "-c", "tinyproxy.conf"]
 
# Add labels for better maintainability
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker image for running tinyproxy"
 
# Expose the default port used by tinyproxy
EXPOSE 3128
