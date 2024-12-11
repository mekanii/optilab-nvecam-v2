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

```sh
ffmpeg -f v4l2 -i /dev/video0
  -f alsa -i hw:0,0
  -c:v libx264 -pix_fmt yuv420p -s 640x480 -r 30 -g 30 -b:v 500k
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