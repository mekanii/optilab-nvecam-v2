```sh
https://github.com/danielkucera/FFmpeg/blob/cedrus264/INSTALL.md
```

```sh
echo '
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet dhcp
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
' | tee /etc/network/interfaces
```

```sh
echo '
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="miconos2"
  psk="miconos1"
  key_mgmt=WPA-PSK
}' | tee /etc/wpa_supplicant/wpa_supplicant.conf
```

```sh
fdisk /dev/mmcblk0
```

```sh
resize2fs /dev/mmcblk0p2
```

```sh
echo '
deb http://archive.debian.org/debian/ stretch main contrib non-free
deb http://archive.debian.org/debian-security/ stretch/updates main contrib non-free
deb http://archive.debian.org/debian/ stretch-updates main contrib non-free
' | tee /etc/apt/sources.list
```

```sh
git clone -b cedrus264 --single-branch https://github.com/danielkucera/FFmpeg.git
git clone https://github.com/danielkucera/FFmpeg.git --branch cedrus264 --single-branch cedrus264
```

```sh
apt update
apt upgrade
```

```sh
apt install ffmpeg
```

- `-ar[:stream_specifier] freq (input/output,per-stream)`
  Set the audio sampling frequency. For output streams it is set by default to the frequency of the corresponding input stream. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.

```sh
#! /bin/bash
#

ABR="128k"
SIZE="1280x720"                              
YOUTUBE="rtmp://a.rtmp.youtube.com/live2"
SOURCE="/dev/video0"             
KEY="1234-5678-1234-7383"                

ffmpeg -re
-ar 44100
-ac 2
-acodec pcm_s16le
-f s16le
-ac 2
-i /dev/zero
-f v4l2
-input_format h264
-video_size 640x480

-i /dev/video0
-codec:v copy
-acodec aac
-ab 128k
-g 50
-strict experimental
-f flv $YOUTUBE/$KEY
```