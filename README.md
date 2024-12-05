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

sudo apt-get install libsrtp2-dev

sudo apt-get install libssl1.1
# or
wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u2_armhf.deb
sudo dpkg -i libssl1.1_1.1.1w-0+deb11u2_armhf.deb

sudo apt-get install libvpx6
# or
wget http://http.us.debian.org/debian/pool/main/libv/libvpx/libvpx6_1.9.0-1+deb11u3_armhf.deb
sudo dpkg -i libvpx6_1.9.0-1+deb11u3_armhf.deb

pip3 uninstall numpy --break-system-packages
pip3 install "numpy<2.0.0" --break-system-packages

pip3 install gunicorn --break-system-packages

sudo apt-get install make

# sudo apt-get install isc-dhcp-server

# sudo mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.bak
# sudo rm -rf /etc/hostapd/hostapd.conf

# echo "
# interface=wlan0
# bridge=br0
# ieee80211n=1
# hw_mode=g
# channel=7
# wmm_enabled=1
# auth_algs=1
# ssid=OptiLab_NVeCam
# wpa_passphrase=12345678
# wpa=2
# wpa_key_mgmt=WPA-PSK
# rsn_pairwise=CCMP" | sudo tee -a /etc/hostapd/hostapd.conf

# sudo sed -i 's/^#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# echo "
# auto lo
# iface lo inet loopback

# allow-hotplug wlan0
# iface wlan0 inet manual
# wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

# iface default inet static
# address 192.168.10.1
# netmask 255.255.255.0" | sudo tee -a /etc/network/interfaces

# sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
# sudo sysctl -p

# sudo sed -i 's/DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf

# sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

# sudo mv /etc/rc.local /etc/rc.bak
# rm -rf /etc/rc.local
# echo "
# iptables-restore < /etc/iptables.ipv4.nat
# exit 0
# " | sudo tee -a /etc/rc.local

# sudo service isc-dhcp-server stop
# sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak

# rm -rf /etc/dhcp/dhcpd.conf

# echo "
# subnet 192.168.10.0 netmask 255.255.255.0 {
#   range 192.168.10.100 192.168.10.200;
#   option routers 192.168.10.1;
#   option subnet-mask 255.255.255.0;
#   option broadcast-address 192.168.10.255;
#   option domain-name \"miconos.co.id\";
#   option domain-name-servers 192.168.10.1, 8.8.8.8;
#   default-lease-time 600;
#   max-lease-time 7200;
# }" | sudo tee -a /etc/dhcp/dhcpd.conf

# sudo sed -i '/^INTERFACESv4=""\|^INTERFACESv6=""/d' /etc/default/isc-dhcp-server

# echo "INTERFACES=\"wlan0\"" | sudo tee -a /etc/default/isc-dhcp-server
# # or
# echo "INTERFACESv4=\"wlan0\"" | sudo tee -a /etc/default/isc-dhcp-server

# sudo sed -i 's/^INTERFACES=""/INTERFACES="wlan0"/' /etc/default/isc-dhcp-server
# sudo sed -i 's/^INTERFACES="wlan0"/INTERFACESv4="wlan0"/' /etc/default/isc-dhcp-server

# sudo systemctl restart hostapd
# sudo systemctl enable hostapd
# sudo systemctl status hostapd

# sudo service isc-dhcp-server start

echo "
[Unit]
Description=Create AP Hotspot
After=network.target

[Service]
ExecStart=create_ap -c 7 -n wlan0 OptiLab_NVeCam 12345678 -g 192.168.10.1 --no-virt
Type=simple
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/hotspot_ap.service

sudo systemctl stop wpa_supplicant
sudo systemctl disable wpa_supplicant
sudo systemctl status wpa_supplicant

sudo systemctl enable hotspot_ap
sudo systemctl start hotspot_ap
sudo systemctl status hotspot_ap


```

to run
```bash
gunicorn -w 2 -b 0.0.0.0:8080 wsgi:app --timeout 120 --keep-alive 5 --log-level debug --worker-class gthread --threads 2
gunicorn -w 4 -b 0.0.0.0:8080 wsgi:app --timeout 120 --keep-alive 5 --log-level debug --worker-class gthread --threads 4
```


sudo journalctl -u isc-dhcp-server.service --no-pager