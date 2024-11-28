# OptiLab nVeCam

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
4. microSDHC Card (min 16GB)

## Setup
### 1. Connect to WiFi
List available WiFi networks
```bash
nmcli dev wifi list
```

Connect to WiFi
```bash
sudo nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
sudo nmcli dev wifi connect "miconos2" password "miconos1"
```

### 2. Update your system
```bash
sudo apt-get update
sudo apt-get upgrade
```

### 3. Install Python 3 and pip3
Install Python 3.9 or newer
```bash
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
```

Download and install Python 3.9
```bash
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar -xf Python-3.9.7.tgz
cd Python-3.9.7
./configure --enable-optimizations
sudo make altinstall
```

Check the new Python version
```bash
python3.9 --version
```

### 4. Update pip and setuptools
First, use the trusted host flag
```bash
pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

### 5. Make Python 3 the default (Optional)
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

### 6. Check System Time
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
