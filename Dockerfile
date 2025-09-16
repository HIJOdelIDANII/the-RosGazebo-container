FROM osrf/ros:jazzy-desktop-full@sha256:712bfae9c14caed329c89f05ca3eae680334c65db37a4c46bb11b1b35cced159

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      bash fluxbox net-tools novnc supervisor x11vnc xvfb openssh-client \
      python3-pip iputils-ping dos2unix libpcl-dev ros-jazzy-pcl-msgs \
      ros-jazzy-pcl-ros x11-apps mesa-utils ros-jazzy-ros-gz \
      ros-jazzy-ros-gz-bridge ros-jazzy-ros-gz-sim ttyd; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV HOME=/home/oorbuser \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=580 \
    VNC_SHARED=true \
    RUN_FLUXBOX=yes \
    ROS_SETUP="source /opt/ros/jazzy/setup.bash"

#RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/oorbuser/.bashrc




RUN groupadd -g 1001 oorbuser \
    && useradd -u 1001 -g oorbuser -m -s /bin/bash oorbuser
COPY noVNC-0.6.2 /home/oorbuser/novnc/ 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown oorbuser:oorbuser /usr/bin/supervisord \
    && chown oorbuser:oorbuser /usr/bin/startfluxbox \
    && chmod 700 /usr/bin/supervisord \ 
    && chmod +x /home/oorbuser/novnc/utils/launch.sh \
    && mkdir -p /var/supervisor && chown oorbuser:oorbuser /var/supervisor \ 
    && ln -s /home/oorbuser/novnc/vnc_auto.html /home/oorbuser/novnc/index.html\
    && echo "source /opt/ros/jazzy/setup.bash" >> /home/oorbuser/.bashrc \
    && usermod -s /usr/sbin/nologin root

USER oorbuser
WORKDIR /workspace

EXPOSE 8080 7681
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf", "-u", "oorbuser", "-n", "-l", "/var/supervisor/supervisord.log", "--pidfile", "/var/supervisor/supervisord.pid"]
