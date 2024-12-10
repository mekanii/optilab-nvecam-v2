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
reboot
```

```sh
resize2fs /dev/mmcblk0p2
```

```sh
ip a
```

```sh
echo '
deb http://archive.debian.org/debian/ stretch main contrib non-free
deb http://archive.debian.org/debian-security/ stretch/updates main contrib non-free
deb http://archive.debian.org/debian/ stretch-updates main contrib non-free
' | tee /etc/apt/sources.list
```

# uv4l
Add the uv4l key to your apt-key package manager:
```sh
curl https://www.linux-projects.org/listing/uv4l_repo/lpkey.asc | sudo apt-key add -
```
or
```sh
wget -qO - https://www.linux-projects.org/listing/uv4l_repo/lpkey.asc | sudo apt-key add -
```

Add the following line to /etc/apt/sources.list:
```sh
echo "deb https://www.linux-projects.org/listing/uv4l_repo/raspbian/stretch stretch main" | tee /etc/apt/sources.list.d/uv4l.list
```

Update the system:
```sh
apt-get update
```

Fetch and install the packages:
```sh
apt-get install uv4l uv4l-server uv4l-uvc uv4l-mjpegstream uv4l-webrtc uv4l-dummy
```

```sh
apt-get install v4l-utils
```

```sh
v4l2-ctl --list-devices
```

```sh
cedrus (platform:cedrus):
	/dev/video0

HD USB Camera: HD USB Camera (usb-1c1c000.usb-1):
	/dev/video1
	/dev/video2
```

```sh
v4l2-ctl --all -d /dev/video0
```

```sh
Driver Info (not using libv4l2):
	Driver name   : cedrus
	Card type     : cedrus
	Bus info      : platform:cedrus
	Driver version: 5.3.5
	Capabilities  : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
Priority: 2
Format Video Capture:
	Width/Height      : 16/32
	Pixel Format      : 'ST12'
	Field             : None
	Bytes per Line    : 32
	Size Image        : 1536
	Colorspace        : Default
	Transfer Function : Default
	YCbCr/HSV Encoding: Default
	Quantization      : Default
	Flags             : 
Format Video Output:
	Width/Height      : 16/16
	Pixel Format      : 'MG2S'
	Field             : None
	Bytes per Line    : 0
	Size Image        : 1024
	Colorspace        : Default
	Transfer Function : Default
	YCbCr/HSV Encoding: Default
	Quantization      : Default
	Flags             : 
        mpeg_2_slice_parameters (unknown): type=103 flags=has-payload
   mpeg_2_quantization_matrices (unknown): type=104 flags=has-payload
    h264_sequence_parameter_set (unknown): type=110 flags=has-payload
     h264_picture_parameter_set (unknown): type=111 flags=has-payload
            h264_scaling_matrix (unknown): type=112 flags=has-payload
          h264_slice_parameters (unknown): type=113 flags=has-payload
         h264_decode_parameters (unknown): type=114 flags=has-payload
```

```sh
v4l2-ctl --all -d /dev/video1
```

```sh
Driver Info (not using libv4l2):
	Driver name   : uvcvideo
	Card type     : HD USB Camera: HD USB Camera
	Bus info      : usb-1c1c000.usb-1
	Driver version: 5.3.5
	Capabilities  : 0x84A00001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Priority: 2
Video input : 0 (Camera 1: ok)
Format Video Capture:
	Width/Height      : 640/480
	Pixel Format      : 'MJPG'
	Field             : None
	Bytes per Line    : 0
	Size Image        : 614989
	Colorspace        : sRGB
	Transfer Function : Default
	YCbCr/HSV Encoding: Default
	Quantization      : Default
	Flags             : 
Crop Capability Video Capture:
	Bounds      : Left 0, Top 0, Width 640, Height 480
	Default     : Left 0, Top 0, Width 640, Height 480
	Pixel Aspect: 1/1
Selection: crop_default, Left 0, Top 0, Width 640, Height 480
Selection: crop_bounds, Left 0, Top 0, Width 640, Height 480
Streaming Parameters Video Capture:
	Capabilities     : timeperframe
	Frames per second: 30.000 (30/1)
	Read buffers     : 0
                     brightness (int)    : min=-64 max=64 step=1 default=0 value=0
                       contrast (int)    : min=0 max=95 step=1 default=32 value=32
                     saturation (int)    : min=0 max=128 step=1 default=50 value=50
                            hue (int)    : min=-2000 max=2000 step=1 default=0 value=0
 white_balance_temperature_auto (bool)   : default=1 value=1
                          gamma (int)    : min=100 max=300 step=1 default=100 value=100
                           gain (int)    : min=0 max=100 step=1 default=0 value=0
           power_line_frequency (menu)   : min=0 max=2 default=1 value=1
      white_balance_temperature (int)    : min=2800 max=6500 step=1 default=4600 value=6500 flags=inactive
                      sharpness (int)    : min=1 max=7 step=1 default=2 value=2
         backlight_compensation (int)    : min=0 max=3 step=1 default=1 value=1
                  exposure_auto (menu)   : min=0 max=3 default=3 value=3
              exposure_absolute (int)    : min=1 max=5000 step=1 default=625 value=156 flags=inactive
         exposure_auto_priority (bool)   : default=0 value=1
```

```sh
v4l2-ctl --all -d /dev/video2
```

```sh
Driver Info (not using libv4l2):
	Driver name   : uvcvideo
	Card type     : HD USB Camera: HD USB Camera
	Bus info      : usb-1c1c000.usb-1
	Driver version: 5.3.5
	Capabilities  : 0x84A00001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04A00000
		Streaming
		Extended Pix Format
Priority: 2
```

```sh
sudo openssl genrsa -out selfsign.key 2048 && sudo openssl req -new -x509 -key selfsign.key -out selfsign.crt -sha256

mv selfsign.* /etc/uv4l/

cat /etc/uv4l/uv4l-uvc.conf

uv4l --external-driver --device-name=video0 --server-option '--port=8080'

uv4l --driver uvc --device-id 05a3:9320 --encoding --server-option '--port=8080' --config-file=/etc/uv4l/uv4l-uvc.conf
```
device-path=004:002
device-id=05a3:9320
Bus 004 Device 002: ID 05a3:9320 ARC International Camera

192.168.1.212

https://github.com/pikvm/ustreamer