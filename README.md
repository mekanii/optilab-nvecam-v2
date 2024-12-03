```bash
echo "
auto lo
iface lo inet loopback
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam
/etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp"  | sudo tee -a /etc/network/interfaces

echo "
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid=\"miconos2\"
  psk=\"miconos1\"
}

network={
  ssid=\"OPEN\"
  key_mgmt=NONE
}

" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf

# Create wpa_supplicant configuration
sudo echo 'ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel

network={
  ssid="miconos2"
  psk="miconos1"
  key_mgmt=WPA-PSK
}' | sudo tee /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

# Bring interface up
sudo ip link set wlan0 up

# Scan for networks
sudo iw dev wlan0 scan | grep SSID

# Connect using wpa_supplicant
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install python3-pip

echo -e "[global]\nindex-url = https://www.piwheels.org/simple" | sudo tee /etc/pip.conf

pip3 install "flask[async]" --break-system-packages
pip3 install aiortc --break-system-packages
pip3 install opencv-python-headless --break-system-packages

sudo apt-get install libopenblas-dev
sudo apt-get install libjpeg-dev libtiff-dev libpng-dev
sudo apt-get install libopenjp2-7 libopenjp2-7-dev
sudo apt-get install ffmpeg libavutil-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo apt-get install libgtk-3-0 libgtk-3-dev
sudo apt-get install libatlas-base-dev

pip3 uninstall numpy --break-system-packages
pip3 install "numpy<2.0.0" --break-system-packages

# sudo apt-get install ufw
# sudo ufw allow 8080
# sudo ufw enable

pip3 install gunicorn --break-system-packages
```

to run
```bash
gunicorn -w 4 -b 0.0.0.0:8080 wsgi:app \
    --timeout 120 \
    --keep-alive 5 \
    --log-level debug \
    --worker-class gthread \
    --threads 4
```