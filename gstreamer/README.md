# Prerequisites
Before you begin, ensure you have the following:
- **Orange Pi Zero**
- **Orange Pi OS** (Ubuntu Xenial Server)
- **Balena Etcher** for flashing images
- **Serial Monitor** (e.g., Putty, CoolTerminal)
- **microSDHC Card** (minimum 16GB)
- **USB to Serial TTL Adapter**

# Installation Steps
##  1.  Flash the OS Image:
        - Use Balena Etcher to flash the downloaded OS image onto the microSDHC card.
        - Insert the microSDHC card into the Orange Pi.

##  2. Connect the USB to Serial TTL:
Connect the USB to Serial TTL adapter to the Orange Pi serial port. The wiring is as follows:
# Connect to WiFi
```bash
nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
nmcli dev wifi connect "miconos2" password "miconos1"
```

# Install Required Tools
## Install Python 3.9
Install dependencies
```bash
apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
```

### Download and install Python 3.9
Download the source code
```bash
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
```
Extract the tarball
```bash
tar -xf Python-3.9.7.tgz
cd Python-3.9.7
```
Configure the build
```bash
./configure --enable-optimizations
```
Install without overwriting the default Python
```bash
sudo make altinstall
```

Check the new Python version
```bash
python3.9 --version
```

### Make Python 3.9 the default
Add Python 3.9 as an alternative for the python command and setting its priority to 1
```bash
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.9 1
```

Create the New Symbolic Link
```bash
sudo ln -s /usr/local/bin/pip3.9 /usr/bin/pip3
# pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

Create a link for lsb_release missing file.
```bash
sudo ln -s /usr/share/pyshared/lsb_release.py /usr/local/lib/python3.8/site-packages/lsb_release.py
```

Upgrade pip
```bash
/usr/local/bin/python3.9 -m pip install --upgrade pip
```

```bash
echo -e "[global]\nindex-url = https://www.piwheels.org/simple" | sudo tee /etc/pip.conf
```

<!-- ```bash
pip install setuptools
pip install --upgrade pip
``` -->

## Install GStreamer
```bash
apt-get install gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
```

## Install Flask
```bash
pip install flask
```

# Python Backend with GStreamer
The Python backend will dynamically construct a GStreamer pipeline based on user input.

server.py:
```python
from flask import Flask, render_template, request
import subprocess

app = Flask(_name_)
process = None  # To store the GStreamer subprocess

@app.route('/')
def index():
  return render_template("index.html")

@app.route('/start_stream', methods=['POST'])
def start_stream():
  global process

  # Stop any running GStreamer process
  if process:
      process.terminate()

  # Get parameters from the form
  encoding = request.form.get("encoding")
  bitrate = request.form.get("bitrate")
  resolution = request.form.get("resolution").split('x')
  fps = request.form.get("fps")

  width, height = resolution

  # Construct GStreamer pipeline
  pipeline = (
    f"v4l2src device=/dev/video0 ! video/x-raw,width={width},height={height},framerate={fps}/1 ! "
    f"videoconvert ! "
    f"{'x264enc bitrate=' + bitrate if encoding == 'h264' else ''}"
    f"{'jpegenc' if encoding == 'mjpeg' else ''}"
    f"{'vp8enc' if encoding == 'vp8' else ''} ! "
    f"rtpjpegpay name=pay0 ! "
    f"udpsink host=0.0.0.0 port=5000"
  )

  # Start GStreamer process
  process = subprocess.Popen(pipeline, shell=True)

  return "Streaming started!"

@app.route('/stop_stream', methods=['POST'])
def stop_stream():
  global process
  if process:
    process.terminate()
    process = None
  return "Streaming stopped!"

if _name_ == '_main_':
  app.run(host='0.0.0.0', port=8080)
```

# HTML Interface
The HTML allows users to configure encoding, bitrate, resolution, and frame rate.

templates/index.html:
```html
<!DOCTYPE html>
<html>
<head>
  <title>Camera Stream Control</title>
</head>
<body>
  <h1>Camera Streaming</h1>
  <form action="/start_stream" method="post">
    <label for="encoding">Encoding:</label>
    <select name="encoding" id="encoding">
      <option value="h264">H.264</option>
      <option value="mjpeg">MJPEG</option>
      <option value="vp8">VP8</option>
    </select><br><br>

    <label for="bitrate">Bitrate (kbps):</label>
    <input type="number" name="bitrate" id="bitrate" value="1000"><br><br>

    <label for="resolution">Resolution:</label>
    <select name="resolution" id="resolution">
      <option value="640x480">640x480</option>
      <option value="1280x720">1280x720</option>
      <option value="1920x1080">1920x1080</option>
    </select><br><br>

    <label for="fps">Frame Rate (FPS):</label>
    <input type="number" name="fps" id="fps" value="30"><br><br>

    <button type="submit">Start Stream</button>
  </form>

  <form action="/stop_stream" method="post">
    <button type="submit">Stop Stream</button>
  </form>
</body>
</html>
```