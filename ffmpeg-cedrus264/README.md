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

Download SimpleRTSP server package:
```sh
wget https://github.com/bluenviron/mediamtx/releases/download/v1.10.0/mediamtx_v1.10.0_linux_armv7.tar.gz
```

Extract downloaded package:
```sh
tar -xzvf mediamtx_v1.10.0_linux_armv7.tar.gz
```

Start the server:
```sh
./mediamtx
```

```
MediaMTX v1.10.0
configuration loaded from /root/mediamtx.yml
[RTSP] listener opened on :8554 (TCP), :8000 (UDP/RTP), :8001 (UDP/RTCP)
[RTMP] listener opened on :1935
[HLS] listener opened on :8888
[WebRTC] listener opened on :8889 (HTTP), :8189 (ICE/UDP)
[SRT] listener opened on :8890 (UDP)
```

**_-f fmt (input/output)_**<br>
Force input or output file format. The format is normally auto detected for input files and guessed from the file extension for output files, so this option is not needed in most cases.

**_-i url (input)_**<br>
input file url

**_-c codec_**<br>
Select an encoder (when used before an output file) or a decoder (when used before an input file) for one or more streams. codec is the name of a decoder/encoder or a special value copy (output only) to indicate that the stream is not to be re-encoded.
- -c:v _codec:video_
- -c:a _codec:audio_

**_-pix_fmt[:stream_specifier] format (input/output,per-stream)_**<br>
Set pixel format. Use -pix_fmts to show all the supported pixel formats. If the selected pixel format can not be selected, ffmpeg will print a warning and select the best pixel format supported by the encoder. If pix_fmt is prefixed by a +, ffmpeg will exit with an error if the requested pixel format can not be selected, and automatic conversions inside filtergraphs are disabled. If pix_fmt is a single +, ffmpeg selects the same pixel format as the input (or graph output) and automatic conversions are disabled.

**_-s[:stream_specifier] size (input/output,per-stream)_**<br>
Set frame size.
As an input option, this is a shortcut for the video_size private option, recognized by some demuxers for which the frame size is either not stored in the file or is configurable – e.g. raw video or video grabbers.
As an output option, this inserts the scale video filter to the end of the corresponding filtergraph. Please use the scale filter directly to insert it at the beginning or some other place.
The format is ‘wxh’ (default - same as source).

**_-r[:stream_specifier] fps (input/output,per-stream)_**<br>
Set frame rate (Hz value, fraction or abbreviation).
As an input option, ignore any timestamps stored in the file and instead generate timestamps assuming constant frame rate fps. This is not the same as the -framerate option used for some input formats like image2 or v4l2 (it used to be the same in older versions of FFmpeg). If in doubt use -framerate instead of the input option -r.
As an output option:
- video encoding<br>
Duplicate or drop frames right before encoding them to achieve constant output frame rate fps.
- video streamcopy<br>
Indicate to the muxer that fps is the stream frame rate. No data is dropped or duplicated in this case. This may produce invalid files if fps does not match the actual stream frame rate as determined by packet timestamps. See also the setts bitstream filter.

**_-g GOP_**<br>
Use a 2 second GOP (Group of Pictures), so simply multiply your output frame rate * 2. For example, if your input is -framerate 30, then use -g 60.

**_-b bitrate_**<br>
bitrate expressed in Kbits/s
- -b:v _bitrate_video_
- -b:a _bitrate_audio_

**_-ar[:stream_specifier] freq (input/output,per-stream)_**<br>
Set the audio sampling frequency. For output streams it is set by default to the frequency of the corresponding input stream. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.

**_-ac[:stream_specifier] channels (input/output,per-stream)_**<br>
Set the number of audio channels. For output streams it is set by default to the number of input audio channels. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.

**_-preset preset_name_**<br>
Provides the compression to encoding speed ratio. Try **_-preset veryfast_** if you are unsure of what to choose, then watch the console output or the video to see if the encoder is keeping up with your desired output frame rate: if it is not then use a faster preset and/or reduce your width x height or frame rate.
preset_name:
- ultrafast
- superfast
- veryfast
- faster
- fast
- medium
- slow
- slower
- veryslow
- placebo

**__**

Test record 640x480 yuyv h.264-enc b:v 700k -> 24fps - 30fps
```sh
ffmpeg -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate 30 -i /dev/video0 -b:v 700k -c:v libx264_omx -preset ultrafast -tune zerolatency test-ffmpeg-output/yuyv_h264_640x480.mp4
```
Test record 800x600 yuyv h.264-enc b:v 800k -> 12fps - 20fps
```sh
ffmpeg -f v4l2 -input_format yuyv -video_size 800x600 -framerate 30 -i /dev/video0 -b:v 800k -c:v libx264 -preset ultrafast -tune zerolatency test-ffmpeg-output/yuyv_h264_800x600.mp4
```
Test record 800x600 mjpeg h.264-enc -> 24fps - 30fps
```sh
ffmpeg -f v4l2 -input_format mjpeg -video_size 800x600 -framerate 30 -i /dev/video0 -c:v libx264 -preset ultrafast -tune zerolatency test-ffmpega-output/mjpeg_h264_800x600.mp4
```
Test record 640x480 mjpeg h.264-enc -> 24fps - 30fps
```sh
ffmpeg -f v4l2 -input_format mjpeg -video_size 640x480 -framerate 30 -i /dev/video0 -c:v libx264 -preset ultrafast -tune zerolatency test-ffmpega-output/mjpeg_h264_640x480.mp4
```

Test stream to YouTube:
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

Move the server executable and configuration in global folders:
```sh
mv mediamtx /usr/local/bin/
mv mediamtx.yaml /usr/local/etc/
```

```sh
/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yaml
```
192.168.1.217:8889/stream480

Create a systemd service:
```sh
tee /etc/systemd/system/mediamtx.service >/dev/null << EOF
[Unit]
Wants=network.target
[Service]
ExecStart=/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yaml
[Install]
WantedBy=multi-user.target
EOF
```

Make service permission executeable:
```sh
chmod 755 /etc/systemd/system/mediamtx.service
```

Enable and start the service:
```sh
sudo systemctl daemon-reload
sudo systemctl enable mediamtx
sudo systemctl start mediamtx
```

```sh
echo '
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.10.1
  netmask 255.255.255.0
  broadcast 192.168.10.255
  network 192.168.10.0
' | tee /etc/network/interfaces
```

```sh
echo '
interface=wlan0
ssid=OptiLab_NVeCam
wpa_passphrase=12345678
hw_mode=g
ieee80211n=1
channel=6
wmm_enabled=1
ignore_broadcast_ssid=0
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
' | tee /etc/hostapd/hostapd.conf
```

```bash
sed -i 's|^#DAEMON_CONF="/etc/hostapd.conf"|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```

```bash
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak

echo '
default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.10.255;
option routers 192.168.10.1;
option domain-name-servers 192.168.10.1,8.8.8.8;
option domain-name "miconos.co.id";
subnet 192.168.10.0 netmask 255.255.255.0 {
range 192.168.10.100 192.168.10.150;
}
' | tee /etc/dhcp/dhcpd.conf

sed -i 's|^INTERFACES=""|INTERFACES="wlan0"|' /etc/default/isc-dhcp-server

sed -i 's|^#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

iptables -L -n -v

sh -c "iptables-save > /etc/iptables.ipv4.nat"

echo '
iptables-restore < /etc/iptables.ipv4.nat
exit 0
' | tee /etc/rc.local
```

```sh
systemctl daemon-reload

systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

systemctl start hostapd
systemctl enable hostapd

systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server

```