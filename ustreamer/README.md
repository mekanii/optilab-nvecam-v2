```bash
apt install libevent-dev libjpeg62-turbo-dev libbsd-dev

# WITH_GPIO=1
apt install libgpiod-dev

# WITH_SYSTEMD=1
apt install libsystemd-dev

# WITH_JANUS=1
apt install libasound2-dev libspeex-dev libspeexdsp-dev libopus-dev

apt install make gcc build-essential pkg-config

libjpeg-dev
```

```bash
echo '
network:
  version: 2
  renderer: NetworkManager
  wifis:
    wlan0:
      dhcp4: no
      addresses: [192.168.10.1/24]
      access-points:
        "optilab":
          password: "12345678"
' | tee /etc/netplan/30-wifis-dhcp.yaml
```

```bash
./ustreamer -d /dev/video0 -r 640x480 -m MJPEG -s 0.0.0.0 -p 8080

./ustreamer -d /dev/video0 --h264-sink=demo::ustreamer::h264 --h264-sink-mode=660 -s 0.0.0.0 -p 8080
```