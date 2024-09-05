# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV USER root

# Update and install dependencies, add the 'universe' repository
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository universe && \
    apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    sudo \
    && apt-get clean

# Create VNC configuration directory
RUN mkdir -p /root/.vnc

# Set VNC password (here it's 'password', change it if necessary)
RUN echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Configure VNC to start with XFCE
RUN echo "#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Expose port 5901 for the VNC server
EXPOSE 5901

# Start VNC server with the desktop environment in foreground mode
CMD ["vncserver", "-fg", ":1"]
