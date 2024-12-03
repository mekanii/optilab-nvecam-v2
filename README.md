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

## System Update
```bash
sudo apt-get update
sudo apt-get upgrade
```

## Install Python 3.9
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

<!-- ## Install and Upgrade pip
```bash
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python get-pip.py
pip install --upgrade setuptools
```
or
```bash
sudo apt-get install python-pip && pip install --upgrade pip
``` -->

## Create or Modify the pip Configuration File
Change from packages source from PyPi to piwheels
```bash
echo -e "[global]\nindex-url = https://www.piwheels.org/simple" | sudo tee /etc/pip.conf
```

## OpenCV
### Install Additional Dependencies (if needed)
If you are using OpenCV with additional features (like GUI support), you may need to install additional dependencies.
```bash
# Install developer tools:
sudo apt-get install build-essential cmake pkg-config

# Install the IO package
sudo apt-get install python-dev python2.7-dev python3.5-dev python3.9-dev python-numpy 
sudo apt-get install libtbb2 libtbb-dev libjpeg-dev libtiff-dev libjasper-dev libpng-dev libdc1394-22-dev

# although it’s unlikely that you’ll be doing a lot of video processing
sudo apt-get install ffmpeg libavutil-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev

# GTK development library for OpenCV’s GUI interface
sudo apt-get install libgtk2.0-dev

# routine optimization packages leveraged by OpenCV
sudo apt-get install libatlas-base-dev gfortran
```

### Install Numpy
```bash
pip3 install numpy
```

### Install OpenCV
Tools to deal with the video frames
```bash
sudo apt-get python-opencv
```

## Flask
Package to build a simple web app
```bash
pip3 install -v "Flask[async]"
```

## WebRTC
To add real-time streaming capability to our web app. We’ll directly be using aiortc python package which combines WebRTC and asyncio.
```bash
pip3 install -v aiortc
```

## Git Clone
```bash
git clone https://github.com/mekanii/optilab-nvecam-v2
```