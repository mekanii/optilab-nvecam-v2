## Installing Dependencies
Installs essential packages for building software from source (build-essential) and a tool for managing library compile/link flags (pkg-config).
```sh
sudo apt-get install build-essential pkg-config
```

Installs development libraries for video4linux `libv4l-dev`, VP8/VP9 video codec `libvpx-dev`, WebP image format `libwep-dev`, and OpenMAX IL `libomxil-bellagio-dev`. Provides necessary libraries for FFmpeg to support various video and image formats.
```sh
sudo apt-get install libv4l-dev libvpx-dev libwep-dev libomxil-bellagio-dev
```

## Building and Installing FFmpeg
Configures the FFmpeg build with support for GPL-licensed components, video4linux2, OpenMAX, VP8/VP9, WebP, and H.264.
```sh
./configure --enable-gpl --enable-libv4l2 --enable-omx --enable-libvpx --enable-libwebp --enable-libx264
```

Compiles and installs FFmpeg and its components to the system.
```sh
sudo make install
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

## Downloading and Setting Up Mediamtx Server
Downloads the mediamtx server package for ARM64 architecture. The server software needed to stream media over RTSP.
```sh
wget https://github.com/bluenviron/mediamtx/releases/download/v1.10.0/mediamtx_v1.10.0_linux_arm64v8.tar.gz
```

Extracts the contents of the downloaded tarball.
```sh
tar -xzvf mediamtx_v1.10.0_linux_armv7.tar.gz
```

Start the mediamtx.
```sh
./mediamtx
```

This output provides a comprehensive overview of the various streaming protocols and ports that the MediaMTX server is configured to handle, ensuring that it can support a wide range of streaming scenarios and client connections.
```
MediaMTX v1.10.0
configuration loaded from /root/mediamtx.yml
[RTSP] listener opened on :8554 (TCP), :8000 (UDP/RTP), :8001 (UDP/RTCP)
[RTMP] listener opened on :1935
[HLS] listener opened on :8888
[WebRTC] listener opened on :8889 (HTTP), :8189 (ICE/UDP)
[SRT] listener opened on :8890 (UDP)
```

Moves the server executable and configuration file to standard directories for executables and configurations.
```sh
sudo mv mediamtx /usr/local/bin/
sudo mv mediamtx.yml /usr/local/etc/
```

Starts the server using the configuration file.
```sh
/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
```

## Setting Up a Wireless Access Point

Installs software to create a wireless access point (hostapd) and a DHCP server (isc-dhcp-server).
```bash
sudo apt-get install hostapd isc-dhcp-server
```

Configures the network interface for the wireless access point. Sets a static IP for the wireless interface to act as a gateway.
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

Configures the wireless access point settings, including SSID and security.
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

Updates the default configuration file to point to the custom hostapd configuration.
```sh
sudo sed -i 's|^#DAEMON_CONF="/etc/hostapd.conf"|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```

Renames the existing DHCP server configuration file (dhcpd.conf) to dhcpd.bak, effectively creating a backup of the original configuration. This step is crucial before making changes to the DHCP configuration, allowing you to restore the original settings if needed.
```sh
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak
```

Writes a new DHCP configuration to /etc/dhcp/dhcpd.conf. This configuration defines a subnet and specifies the range of IP addresses that can be assigned to clients, along with other network options.<br>
Sets up a DHCP server to provide IP addresses and network configuration to devices on the `192.168.10.0/24` subnet. This configuration is essential for devices connecting to the wireless access point to receive network settings automatically.
```sh
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
```

Modifies the `/etc/default/isc-dhcp-server` configuration file to specify that the DHCP server should listen on the `wlan0` interface. This Ensures that the DHCP server provides IP addresses and network configuration to devices connected to the `wlan0` interface, typically used for a wireless access point.
```sh
sudo sed -i 's|^INTERFACES=""|INTERFACES="wlan0"|' /etc/default/isc-dhcp-server
```

## Setup Web Page UI

Clones the optilab-nvecam-v2 repository from GitHub to your local machine. This creates a local copy of the repository, including all files and commit history. Used to obtain the source code and resources for the OptiLab NVeCam project, allowing you to work on or deploy the application.
```sh
git clone https://github.com/mekanii/optilab-nvecam-v2/
```

Changes the current directory to ffmpeg-mediamtx within the cloned optilab-nvecam-v2 repository.
```sh
cd optilab-nvecam-v2/ffmpeg-mediamtx
```

Creates a virtual environment named venv using Python 3.9. A virtual environment is an isolated Python environment that allows you to manage dependencies separately from the system Python installation.
```sh
python3.9 -m venv venv
```

Activates the virtual environment created in the previous step. This modifies the shell environment to use the Python interpreter and libraries from the virtual environment.
```sh
source venv/bin/activate
```

Installs the Flask web framework into the activated virtual environment. Flask is a lightweight WSGI web application framework designed for building web applications quickly and with minimal overhead.
```sh
pip3.9 install Flask
```

Installs the Flask-SocketIO package. This package enables WebSocket support in Flask applications, allowing for real-time communication between the client and server.
```sh
pip3.9 install flask-socketio
```

Installs the gunicorn package. Gunicorn is a Python WSGI HTTP server for UNIX, designed to serve Python web applications in a production environment.
```sh
pip3.9 install gunicorn
```

Installs the eventlet package. Eventlet is a concurrent networking library for Python that provides support for asynchronous I/O. Used with Flask-SocketIO to handle WebSocket connections efficiently.
```sh
pip3.9 install eventlet
```

## Disable _sudo_ Password for User
Adds a configuration to the sudoers file that allows the **orangepi** user to execute any command without being prompted for a password. Useful for automating tasks that require sudo privileges without manual intervention.
```sh
echo 'orangepi ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/orangepi
```

```sh
sudo chmod 440 /etc/sudoers.d/orangepi
```

## Creating and Managing a Systemd Service

Creates a systemd service file for the MediaMTX server.
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

Sets the correct permissions for the service file.
```sh
sudo chmod 755 /etc/systemd/system/mediamtx.service
```

Creates a systemd service file for the OptiLab NVeCam application. This service runs the application using Gunicorn with the Eventlet worker.
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

Reloads the systemd manager configuration. This is necessary after creating or modifying service files to ensure systemd recognizes the changes.
```sh
sudo systemctl daemon-reload
```

Stops and disables the `NetworkManager` service, which is responsible for managing network connections on many Linux distributions. This is necessary because we manually configuring network interfaces or using another tool (like hostapd for a wireless access point) that conflicts with NetworkManager.
```sh
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
```

Disables the chronyd service, which is a daemon for the chrony package used to synchronize the system clock with NTP servers. Disabling this service can help shorten boot time by reducing the number of services that start automatically.
```sh
sudo systemctl disable chronyd
```

This command sequence stops the `hostapd` and `isc-dhcp-server` services, starts the `NetworkManager` service, and then uses `nmcli` to connect to a Wi-Fi network. This is useful for switching from a manually configured wireless access point setup back to using NetworkManager to manage Wi-Fi connections. It effectively transitions the system from acting as an access point to connecting to an existing Wi-Fi network.
```sh
sudo sh -c 'systemctl stop hostapd && systemctl stop isc-dhcp-server && systemctl start NetworkManager.service && nmcli dev wifi connect "miconos2" password "miconos1" && exit 0'
```

Starts the services immediately.
```sh
sudo systemctl start hostapd
sudo systemctl start isc-dhcp-server
sudo systemctl start mediamtx
sudo systemctl start optilab-nvecam.service
```

Displays the logs for the services from the current boot. The `--no-pager` option prevents paging, and `-l` ensures long lines are not truncated. Useful for troubleshooting and monitoring the service to ensure it is running correctly.
```sh
journalctl -u hostapd.service -b --no-pager -l
journalctl -u isc-dhcp-server.service -b --no-pager -l
journalctl -u mediamtx.service -b --no-pager -l
journalctl -u optilab-nvecam.service -b --no-pager -l
```

Enables the services to start automatically at boot.
```sh
sudo systemctl enable hostapd
sudo systemctl enable isc-dhcp-server
sudo systemctl enable mediamtx
sudo systemctl enable optilab-nvecam.service
```