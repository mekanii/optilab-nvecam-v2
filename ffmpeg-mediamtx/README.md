Install dependencies:
```sh
sudo apt-get install build-essential pkg-config
sudo apt-get install libv4l-dev libvpx-dev libwep-dev libomxil-bellagio-dev
```

Create the configuration:
```sh
./configure --enable-gpl --enable-libv4l2 --enable-omx --enable-libvpx --enable-libwebp --enable-libx264
```

Build FFmpeg and install all binaries:
```sh
sudo make install
```

Download SimpleRTSP server package:
```sh
wget https://github.com/bluenviron/mediamtx/releases/download/v1.10.0/mediamtx_v1.10.0_linux_arm64v8.tar.gz
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

Move the server executable and configuration in global folders:
```sh
sudo mv mediamtx /usr/local/bin/
sudo mv mediamtx.yml /usr/local/etc/
```

Start the server:
```sh
/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
```

Create a systemd service:
```sh
sudo tee /etc/systemd/system/mediamtx.service >/dev/null << EOF
[Unit]
Wants=network.target
[Service]
ExecStart=/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
[Install]
WantedBy=multi-user.target
EOF
```

Make service permission executeable:
```sh
sudo chmod 755 /etc/systemd/system/mediamtx.service
```

Enable and start the service:
```sh
sudo systemctl daemon-reload
sudo systemctl enable mediamtx
sudo systemctl start mediamtx
```

```bash
sudo apt-get install hostapd
sudo apt-get install isc-dhcp-server
```

```sh
echo '
auto lo
iface lo inet loopback

allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.10.1
  netmask 255.255.255.0
  broadcast 192.168.10.255
  network 192.168.10.0
' | sudo tee /etc/network/interfaces
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
' | sudo tee /etc/hostapd/hostapd.conf
```

```bash
sudo sed -i 's|^#DAEMON_CONF="/etc/hostapd.conf"|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```

```bash
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak

echo '
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.100 192.168.10.150;
  default-lease-time 600;
  max-lease-time 7200;
  option subnet-mask 255.255.255.0;
  option broadcast-address 192.168.10.255;
  option routers 192.168.10.1;
  option domain-name-servers 192.168.10.1,8.8.8.8;
  option domain-name "miconos.co.id";
}
' | sudo tee /etc/dhcp/dhcpd.conf

sudo sed -i 's|^INTERFACES=""|INTERFACES="wlan0"|' /etc/default/isc-dhcp-server

sudo sed -i 's|^#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo iptables -L -n -v

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"


```sh
echo '
[Unit]
Description=iptables-restore

[Service]
Type=forking
ExecStart=/bin/sh -c "iptables-restore < /etc/iptables.ipv4.nat && exit 0"
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
' | sudo tee /etc/systemd/system/rc-local.service
```

```sh
sudo systemctl daemon-reload

sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service

sudo systemctl disable chronyd

sudo systemctl start rc-local.service
sudo systemctl enable rc-local.service

sudo systemctl start hostapd
sudo systemctl enable hostapd

sudo systemctl start isc-dhcp-server
sudo systemctl enable isc-dhcp-server
```

```sh
sudo sh -c 'systemctl stop hostapd && systemctl stop isc-dhcp-server && systemctl start NetworkManager.service && nmcli dev wifi connect "miconos2" password "miconos1" && exit 0'
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

```sh
git clone https://github.com/mekanii/optilab-nvecam-v2/
```

```sh
cd optilab-nvecam-v2/ffmpeg-mediamtx
```

Set up a virtual environment:
```sh
  python3.9 -m venv venv
```

Activate the virtual environment to use the isolated Python environment:
```sh
  source venv/bin/activate
```

Install Flask using pip:
```sh
  pip3.9 install Flask
```

```sh
  pip3.9 install flask-socketio
```

```sh
  pip3.9 install gunicorn
```

```sh
  pip3.9 install eventlet
```

```sh
echo 'mekanii ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/mekanii
```

```sh
sudo chmod 440 /etc/sudoers.d/mekanii
```

```sh
echo '
[Unit]
Description=OptiLab NVeCam Service
Wants=network.target

[Service]
Type=simple
WorkingDirectory=/home/orangepi/optilab-nvecam-v2/ffmpeg-mediamtx
ExecStart=/bin/bash -c "source venv/bin/activate && exec gunicorn -k eventlet -w 1 -b 0.0.0.0:1994 server:app"
Restart=on-failure

[Install]
WantedBy=multi-user.target
' | sudo tee /etc/systemd/system/optilab-nvecam.service
```

```sh
sudo systemctl daemon-reload

sudo systemctl enable optilab-nvecam.service
sudo systemctl start optilab-nvecam.service

journalctl -u optilab-nvecam.service -b --no-pager -l
```