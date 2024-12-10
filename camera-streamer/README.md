```bash
echo '
network:
  version: 2
  renderer: networkd
  wifis:
    wlan0:
      dhcp4: true
      dhcp6: true
      access-points:
        "miconos2":
          password: "miconos1"
' | tee /etc/netplan/30-wifis-dhcp.yaml

chmod 600 /etc/netplan/*.yaml

sudo netplan try

git clone https://github.com/ayufan-research/camera-streamer.git --recursive
apt -y install libavformat-dev libavutil-dev libavcodec-dev libcamera-dev v4l-utils pkg-config xxd build-essential cmake libssl-dev
apt -y install liblivemedia-dev

cd camera-streamer/
make
sudo make install

PACKAGE=camera-streamer-generic_0.2.8.bookworm_armhf.deb
wget "https://github.com/ayufan/camera-streamer/releases/download/v0.2.8/$PACKAGE"
apt install "$PWD/$PACKAGE"

cp /usr/share/camera-streamer/examples/camera-streamer-generic-usb-cam.service /etc/systemd/system/camera-streamer.service

cat /etc/systemd/system/camera-streamer.service

echo '
[Unit]
Description=camera-streamer web camera for USB camera on Generic platform
After=network.target
ConditionPathExistsGlob=/dev/v4l/by-id/usb-*-video-index0

[Service]
ExecStart=/usr/bin/camera-streamer \
  -camera-path=/dev/video0 \
  -camera-format=JPEG \
  -camera-width=1920 -camera-height=1080 \
  -camera-fps=30 \
  ; use two memory buffers to optimise usage
  -camera-nbufs=3 \
  --http-listen=0.0.0.0 \
  --http-port=8080 \
  ; disable video streaming (WebRTC, RTSP, H264)
  ; on non-supported platforms
  -camera-video.disabled

DynamicUser=yes
Restart=always
RestartSec=10
Nice=10
IOSchedulingClass=idle
IOSchedulingPriority=7
CPUWeight=20
AllowedCPUs=1-2
MemoryMax=250M

[Install]
WantedBy=multi-user.target
' | tee /etc/systemd/system/camera-streamer.service

chmod 755 /etc/systemd/system/camera-streamer.service

systemctl enable camera-streamer
systemctl start camera-streamer

systemctl enable /usr/share/camera-streamer/examples/camera-streamer-generic-usb-cam.service
systemctl start camera-streamer-generic-usb-cam
```