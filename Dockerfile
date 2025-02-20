# Sử dụng Ubuntu làm base image
FROM ubuntu:latest

# Cập nhật và cài đặt các gói cần thiết
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    git \
    python3-pip \
    x11vnc \
    websockify \
    xterm \
    supervisor \
    && apt-get clean

# Cài đặt noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html

# Thiết lập môi trường Xfce
RUN mkdir -p ~/.vnc && echo "startxfce4 &" > ~/.vnc/xstartup \
    && chmod +x ~/.vnc/xstartup

# Cấu hình VNC và noVNC
ENV USER root
ENV PASSWORD secret

# Thiết lập port VNC và noVNC
EXPOSE 5901 6080

# Khởi tạo VNC server
RUN echo "root:${PASSWORD}" | chpasswd

# Lệnh để khởi động VNC server và noVNC
CMD ["bash", "-c", "vncserver :1 -geometry 1280x1024 -depth 24 && /opt/noVNC/utils/launch.sh --vnc localhost:5901"]
