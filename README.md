# OptiLab nVeCam

Kamera Pemeriksaan Serviks

## Features

## Pre-requisites

Orange Pi Zero 2.1.0 Ubuntu Xenial Server Linux 3.4.113

https://etcher.balena.io/#download-etcher

### Connect to WiFi
```
# List available WiFi networks
nmcli dev wifi list

# Connect to WiFi
sudo nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
sudo nmcli dev wifi connect "miconos2" password "miconos1"
```

### 1. First, update your system
```
sudo apt-get update
sudo apt-get upgrade
```

### 2. Install Python 3 and pip3
```
# Install Python 3.9 or newer
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev \
  libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev

# Download and install Python 3.9
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar -xf Python-3.9.7.tgz
cd Python-3.9.7
./configure --enable-optimizations
sudo make altinstall

# Check the new Python version
python3.9 --version
```

### 4. Update pip and setuptools
```
# First, use the trusted host flag
pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

### 5. Make Python 3 the default (Optional)
```
# Create aliases in .bashrc
sudo nano ~/.bashrc

# Add these lines at the end of the file:
alias python=python3.9
alias pip=pip3
```

Then apply changes:
```
source ~/.bashrc
```

### Check System Time
```
# Check current time
date

# If incorrect, update it
sudo apt-get install ntpdate
sudo ntpdate pool.ntp.org

# or
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
```

### Tips
1. Don't remove Python 2.7 as it might break system tools
2. Always use virtual environments for projects
3. If space is an issue, you can remove unnecessary packages:
```
sudo apt-get autoremove
```
4. To check disk space
```
df -h
```
Remember to backup any important data before making significant system changes!
