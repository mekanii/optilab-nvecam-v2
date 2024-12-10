# Prerequisites
Before you begin, ensure you have the following:
- **Orange Pi Zero**
- **Orange Pi OS** (Ubuntu Xenial Server)
- **Balena Etcher** for flashing images
- **Serial Monitor** (e.g., Putty, CoolTerminal)
- **microSDHC Card** (minimum 16GB)
- **USB to Serial TTL Adapter**

# Installation Steps
##  1. Flash the OS Image:
- Use Balena Etcher to flash the downloaded OS image onto the microSDHC card.
- Insert the microSDHC card into the Orange Pi.

##  2. Connect the USB to Serial TTL:
Connect the USB to Serial TTL adapter to the Orange Pi serial port. The wiring is as follows:
| Orange Pi | USB to Serial TTL |
|-----------|-------------------|
| RX        | TX                |
| TX        | RX                |
| GND       | GND               |

## 3. Open Serial Monitor:
- Connect to the device with a baud rate of 115200.
- Boot up the Orange Pi until you see the login prompt.

## 4. Login:
Use the default credentials:
- Username: `root`
- Password: `orangepi`

# Connect to WiFi
```bash
nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_WIFI_PASSWORD"
nmcli dev wifi connect "miconos2" password "miconos1"
```

# Update System
```bash
apt-get update
apt-get upgrade
```

# Install Python 3.9 and pip3
## Download and install Python3.9
### 1. Install required tools
```bash
apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
```

## 2. Download the source code
```bash
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
```
## 3. Extract the tarball
```bash
tar -xf Python-3.9.7.tgz
cd Python-3.9.7
```

## 4. Configure the build
```bash
./configure --enable-optimizations
```

## 5. Install without overwriting the default Python
```bash
sudo make altinstall
```

## 6. Check the new Python version
```bash
python3.9 --version
```

## 7. Make Python 3.9 the default
- Add Python 3.9 as an alternative for the python command and setting its priority to 1
```bash
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.9 1
```

- Create the New Symbolic Link
```bash
sudo ln -s /usr/local/bin/pip3.9 /usr/bin/pip3
# pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U pip setuptools
```

## Upgrade pip3
### 1. Create a link for lsb_release missing file
```bash
sudo ln -s /usr/share/pyshared/lsb_release.py /usr/local/lib/python3.9/site-packages/lsb_release.py
```

### 2. Upgrade pip
```bash
/usr/local/bin/python3.9 -m pip install --upgrade pip
```

### 3. Check pip version
```bash
pip3 --version
```

```bash
echo -e "[global]\nindex-url = https://www.piwheels.org/simple" | sudo tee /etc/pip.conf
```

<!-- ```bash
pip install setuptools
pip install --upgrade pip
``` -->

# Install GStreamer
```bash
apt-get install gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libgstreamer1.0-dev
```

# Install Flask
```bash
pip3 install flask
```

# GStreamer Service 
## 1. Create service
```bash
echo '
[Unit]
Description=OptiLab NVECam GStreamer Service

[Service]
ExecStart=/bin/bash -c 'python3 optilab-nvecam-v2/gstreamer/server.py'
ExecStop=ExecStop=/usr/bin/pkill -f "python3 optilab-nvecam-v2/gstreamer/server.py"
StandardOutput=journal
StandardError=journal
User=root

[Install]
WantedBy=multi-user.target
' | tee /etc/systemd/system/nvecam-gstreamer.service
```

## 2. systemctl command
To start service:
```bash
systemctl start nvecam-gstreamer
```
To stop service:
```bash
systemctl stop nvecam-gstreamer
```
To restart service:
```bash
systemctl restart nvecam-gstreamer
```
To enable service, so it will active after system boot:
```bash
systemctl enable nvecam-gstreamer
```
To monitor service status:
```bash
systemctl status nvecam-gstreamer --no-pager -l
```

# Access Point
## 1. Install required tools
```bash
apt-get install hostapd
apt-get install isc-dhcp-server
```

## 2. Setup interface
Create /etc/network/interfaces
```bash
echo '
allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.10.1
  netmask 255.255.255.0
  broadcast 192.168.10.255
  network 192.168.10.0
' | tee /etc/network/interfaces
```

## 3. Setup hostapd
### Create /etc/hostapd/hostapd.conf
```bash
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
' | tee /etc/hostapd/hostapd.conf
```

### Update /etc/default/hostapd
Activate **DAEMON_CONF** and change its value from **"/etc/hostapd.conf"** to **"/etc/hostapd/hostapd.conf"**
```bash
sed -i 's|^#DAEMON_CONF="/etc/hostapd.conf"|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```

## 4. Setup dhcp server
### Backup /etc/dhcp/dhcpd.conf
```bash
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak
```

### Create new /etc/dhcp/dhcpd.conf
```bash
echo '
default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.10.255;
option routers 192.168.10.1;
option domain-name-servers 192.168.10.1,8.8.8.8;
option domain-name "miconos.co.id";
subnet 192.168.10.0 netmask 255.255.255.0 {
range 192.168.10.100 192.168.10.150;
}
' | tee /etc/dhcp/dhcpd.conf
```

### Update /etc/default/isc-dhcp-server
Assign **wlan0** to **INTERFACE** value
```bash
sed -i 's|^INTERFACES=""|INTERFACES="wlan0"|' /etc/default/isc-dhcp-server
```

### Update /etc/sysctl.conf
Activate net.ipv4.ip_forward
```bash
sed -i 's|^#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
```

```bash
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
```

### Setup iptables
```bash
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
```

To view current iptables
```bash
sudo iptables -L -n -v
```

```bash
sh -c "iptables-save > /etc/iptables.ipv4.nat"
```

```bash
echo '
iptables-restore < /etc/iptables.ipv4.nat
exit 0
' | tee /etc/rc.local
```

## 5. systemctl command
Stop and disable NetworkManager, otherwise the Access Point service won't start.
```bash
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
```

Reload daemon
```bash
systemctl daemon-reload
```

To start:
```bash
systemctl start hostapd
systemctl start isc-dhcp-server
```

To stop:
```bash
systemctl stop hostapd
systemctl stop isc-dhcp-server
```

To restart:
```bash
systemctl restart hostapd
systemctl restart isc-dhcp-server
```

To enable:
```bash
systemctl enable hostapd
systemctl enable isc-dhcp-server
```

To monitor service status:
```bash
systemctl status hostapd --no-pager -l
systemctl status isc-dhcp-server --no-pager -l
```

wget http://http.us.debian.org/debian/pool/main/g/gcc-10/gcc-10-base_10.2.1-6_armhf.deb
wget http://http.us.debian.org/debian/pool/main/g/gcc-10/libgcc-s1_10.2.1-6_armhf.deb
wget http://http.us.debian.org/debian/pool/main/libf/libffi/libffi7_3.3-6_armhf.deb

dpkg -i gcc-10-base_10.2.1-6_armhf.deb
dpkg -i libgcc-s1_10.2.1-6_armhf.deb
dpkg -i libffi7_3.3-6_armhf.deb

apt-get install python3-gi python3-gi-cairo gir1.2-gtk-3.0