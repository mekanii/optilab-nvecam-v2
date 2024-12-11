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
  <br>Set the audio sampling frequency. For output streams it is set by default to the frequency of the corresponding input stream. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.
- `-ac[:stream_specifier] channels (input/output,per-stream)`
  <br>Set the number of audio channels. For output streams it is set by default to the number of input audio channels. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.
- `-acodec codec (input/output)`
  <br>Set the audio codec. This is an alias for `-codec:a`.
- `-f fmt (input/output)`
  <br>Force input or output file format. The format is normally auto detected for input files and guessed from the file extension for output files, so this option is not needed in most cases.
- `-i url (input)`
  <br>input file url

**_-c codec_**
&nbsp;&nbsp;Select an encoder (when used before an output file) or a decoder (when used before an input file) for one or more streams. codec is the name of a decoder/encoder or a special value copy (output only) to indicate that the stream is not to be re-encoded.
- c:v _codec:video_
- c:a _codec:audio_

**_-pix_fmt[:stream_specifier] format (input/output,per-stream)_**

```sh
ffmpeg -f v4l2 -i /dev/video0
  -f alsa -i hw:0,0
  -c:v libx264 -pix_fmt yuv420p -r 30 -g 30 -b:v 500k
  -c:a aac -b:a 128k -ar 44100 -ac 2
  -preset ultrafast -tune zerolatency
  -f flv rtmp://a.rtmp.youtube.com/live2/a8rx-y9t2-vrxh-cy6p-a5v6





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