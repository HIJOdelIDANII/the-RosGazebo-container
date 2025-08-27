# ROS 2 Jazzy Desktop GUI in Docker with noVNC

This setup allows you to run a full **ROS 2 Jazzy** desktop environment inside a Docker container and access the GUI from your web browser using **noVNC**.


## How It Works

- The container runs a lightweight Linux window manager (**Fluxbox**) with a virtual display (**Xvfb**).  
- **x11vnc** shares the desktop as a VNC server.  
- **noVNC / websockify** exposes the VNC session as a web page, default port **6080** inside the container.  
- You can access ROS desktop applications (e.g., **RViz**, **Gazebo**) from any modern browser.


## Prerequisites

- Docker installed on your host or VM.
- Basic knowledge of ROS 2 Jazzy and Linux terminal.
- Access to the VM’s public IP address if connecting remotely.


## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/OORB-Open-Organic-Robotics/ros2-jazzy-cloud-gui.git
cd ros2-jazzy-cloud-gui/
```
### 2. Setup the VM
```bash
chmod u+x vm_setup.sh
./vm_setup.sh
```
### 3. Download and Unzip noVNC
```bash
wget https://github.com/novnc/noVNC/archive/refs/tags/v0.6.2.zip
unzip v0.6.2.zip
```
## Launching

### 1 . Build the Docker Image
 ```bash
 docker build -t ros2-jazzy-gui .
 ```
### 2 . Run the Docker Container
 ```bash
docker run -it --rm -p 8081:8080 ros2-jazzy-gui
 ```
### 3 . Access the GUI
http://<vm_ip_address>:8081
