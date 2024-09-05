# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER root

# Install required packages including XFCE and VNC
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    x11-xserver-utils \
    xterm \
    && apt-get clean

# Setup the VNC server
RUN mkdir /root/.vnc \
    && echo "password" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Configure VNC to launch XFCE
RUN echo "#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &" > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# Expose the VNC port
EXPOSE 5901

# Start the VNC server and keep the container running
CMD ["vncserver", "-fg", ":1"]
