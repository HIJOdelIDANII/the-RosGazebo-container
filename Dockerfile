FROM osrf/ros:humble-desktop-full
RUN apt-get update

# Installing git, supervisor, x11vnc and fluxbox window manager
RUN set -ex && \
    apt-get update && \
    apt-get install -y \
        bash \
        fluxbox \
        git \
        net-tools \
        novnc \
        supervisor \
        x11vnc \
        xterm \
        xvfb \
        openssh-client \
        vim \
        python3-pip \
        curl \
        iputils-ping \
        dos2unix \
        libpcl-dev \
        ros-humble-pcl-msgs \
        ros-humble-pcl-ros \
        x11-apps \
        mesa-utils && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    gazebo \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=no \
    VNC_SHARED=true \
    RUN_FLUXBOX=yes

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root/
ADD noVNC-0.6.2  /root/novnc/
RUN chmod +x /root/novnc/utils/launch.sh
RUN ln -s /root/novnc/vnc_auto.html /root/novnc/index.html
# change it for best practices
USER root 
EXPOSE 8080

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]