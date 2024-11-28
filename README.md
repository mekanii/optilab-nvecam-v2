# OptiLab NVeCam

Kamera Pemeriksaan Serviks

## Features

## Pre-requisites
1. Orange Pi Zero
2. Orange Pi Zero 2.1.0 Ubuntu Xenial Server Linux 3.4.113
```
https://drive.google.com/file/d/1-bxrAXvkbZrfLR-7JcDn3UHu3VGRrkPf/view?usp=share_link
```
3. Balena Etcher
```
https://etcher.balena.io/#download-etcher
```
4. Serial monitor (Putty, CoolTerminal)
5. microSDHC Card (min 16GB)
6. USB to Serial TTL adapter

## Setup
### Flash Image
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

### Connect to WiFi
List available WiFi networks
```bash
nmcli dev wifi list
```

Connect to WiFi
```bash
sudo nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
```

### System Update
```bash
sudo apt-get update
sudo apt-get upgrade
```

### Install Python 3
Install dependencies
```bash
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
```

#### Download and install Python 3.9
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
Compile the source code
```bash
make
```
Install without overwriting the default Python
```bash
sudo make altinstall
```

Check the new Python version
```bash
python3.9 --version
```

### Update pip and setuptools
First, use the trusted host flag
```bash
pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

### Make Python 3 the default (Optional)
Create aliases in .bashrc
```bash
sudo nano ~/.bashrc
```

Add these lines at the end of the file:
```bash
alias python=python3.9
alias pip=pip3
```

Then apply changes:
```bash
source ~/.bashrc
```

### Check System Time
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

### Tips
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
