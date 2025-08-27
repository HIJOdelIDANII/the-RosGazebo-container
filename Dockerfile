FROM osrf/ros:jazzy-desktop-full

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        bash \
        fluxbox \
        net-tools \
        novnc \
        supervisor \
        x11vnc \
        xvfb \
        openssh-client \
        python3-pip \
        iputils-ping \
        dos2unix \
        libpcl-dev \
        ros-jazzy-pcl-msgs \
        ros-jazzy-pcl-ros \
        x11-apps \
        mesa-utils \
        ros-jazzy-ros-gz \
        ros-jazzy-ros-gz-bridge \
        ros-jazzy-ros-gz-sim; \
    rm -rf /var/lib/apt/lists/*

ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    VNC_SHARED=true \
    RUN_FLUXBOX=yes \
    ROS_SETUP="source /opt/ros/jazzy/setup.bash"

RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD noVNC-0.6.2 /root/novnc/
RUN chmod +x /root/novnc/utils/launch.sh && \
    ln -s /root/novnc/vnc_auto.html /root/novnc/index.html
WORKDIR /root/
USER root  
# change in prod 
EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
