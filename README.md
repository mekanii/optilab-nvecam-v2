# OptiLab NVeCam

Kamera Pemeriksaan Serviks
```
https://github.com/jmaturner/video_streaming_with_flask_example
```

# Features

# Pre-requisites
1. Orange Pi Zero
2. Orange Pi OS
Ubuntu Xenial Server
```

```
or
Debian Stretch Server
```
https://drive.google.com/open?id=1-i4b8kJ4v_T76sUMIsTrMqymu6VYSaqU
```
or
Minimal/IOT images with Armbian Linux v6.6
```
https://dl.armbian.com/orangepizero/Bookworm_current_minimal
```
3. Balena Etcher
```
https://etcher.balena.io/#download-etcher
```
4. Serial monitor (Putty, CoolTerminal)
5. microSDHC Card (min 16GB)
6. USB to Serial TTL adapter

# Setup
## Flash Image
1. Flash OS Image that has been downloaded to microSDHC Card using Balena Etcher.
2. Plug in the microSDHC Card to Orange Pi
3. Plug in the USB to Serial TTL into Orange Pi serial port. The wiring is:

<table>
  <tr>
    <td>Orange Pi</td>
    <td>USB to Serial TTL</td>
  </tr>
  <tr>
    <td>RX</td>
    <td>TX</td>
  </tr>
  <tr>
    <td>TX</td>
    <td>RX</td>
  </tr>
  <tr>
    <td>GND</td>
    <td>GND</td>
  </tr>
</table>

4. Open Serial Monitor, connect to device with baudrate=115200
5. Boot up the Orange Pi till show login prompt
6. Input the default credentials
```
username: root
password: orangepi
```

## Connect to WiFi
List available WiFi networks
```bash
nmcli dev wifi list
```

Connect to WiFi
```bash
sudo nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
```

## System Update
```bash
sudo apt-get update
sudo apt-get upgrade
```

## Check System Time
Check current time
```bash
date
```

If incorrect, update it
```bash
sudo apt-get install ntpdate
sudo ntpdate pool.ntp.org
```
or
```bash
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
```

## Install Python 3
Install dependencies
```bash
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
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

### Make Python 3 the default
Add Python 3.9 as an alternative for the python command and setting its priority to 1
```bash
sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.9 1
```

Create the New Symbolic Link
```bash
sudo ln -s /usr/local/bin/pip3.9 /usr/bin/pip
# pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

Upgrade pip
```bash
/usr/local/bin/python3.9 -m pip install --upgrade pip
```

## Tips
1. Don't remove Python 2.7 as it might break system tools
2. Always use virtual environments for projects
3. If space is an issue, you can remove unnecessary packages:
```bash
sudo apt-get autoremove
```
4. To check disk space
```bash
df -h
```
Remember to backup any important data before making significant system changes!

# NiceGUI
## Install pre-compiled uvloop for armv7l from pywheels
```bash
pip install -v https://www.piwheels.org/simple/uvloop/uvloop-0.21.0-cp39-cp39-linux_armv7l.whl
```

## Install NiceGUI
```bash
pip install -v nicegui
```

# OpenCV
## Install pre-compiled OpenCV for armv7l from pywheels
### Install directly from piwheels
```bash
pip install -v https://www.piwheels.org/simple/numpy/numpy-2.0.2-cp39-cp39-linux_armv7l.whl
```
### Or download it and install
```bash
wget https://www.piwheels.org/simple/numpy/numpy-2.0.2-cp39-cp39-linux_armv7l.whl
```
Verify the Download
```bash
file numpy-2.0.2-cp39-cp39-linux_armv7l.whl
```
Install
```bash
pip install -v numpy-2.0.2-cp39-cp39-linux_armv7l.whl no-cache-dir
```

## Install pre-compiled OpenCV for armv7l from pywheels
### Install directly from piwheels
```bash
pip install -v https://www.piwheels.org/simple/opencv-python/opencv_python-4.6.0.66-cp39-cp39-linux_armv7l.whl
```
### Or download it and install
Download the file
```bash
wget https://www.piwheels.org/simple/opencv-python/opencv_python-4.6.0.66-cp39-cp39-linux_armv7l.whl
```
Verify the Download
```bash
file opencv_python-4.6.0.66-cp39-cp39-linux_armv7l.whl
```
Install
```bash
pip install -v opencv_python-4.6.0.66-cp39-cp39-linux_armv7l.whl no-cache-dir
```

## Install Additional Dependencies (if needed)
If you are using OpenCV with additional features (like GUI support), you may need to install additional dependencies.
```bash
# Install developer tools:
sudo apt-get install build-essential cmake pkg-config

# Install the IO package
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev

# although it’s unlikely that you’ll be doing a lot of video processing
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install libxvidcore-dev libx264-dev

# GTK development library for OpenCV’s GUI interface
sudo apt-get install libgtk2.0-dev

# routine optimization packages leveraged by OpenCV
sudo apt-get install libatlas-base-dev gfortran
```
