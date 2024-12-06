```bash
sudo apt-get install cmake libjpeg8-dev
sudo apt-get install gcc g++

git clone https://github.com/jacksonliam/mjpg-streamer.git

cd ~/mjpg-streamer/mjpg-streamer-experimental

make
make install
```

```bash
echo '/usr/local/bin/mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 640x480 -f 30 -q 80" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www -n"' | sudo tee mjpg-stream

chmod 755 mjpg-stream
```

```bash
echo '
[Unit]
Description=Script to run mjpg-stream

[Service]
ExecStart=/usr/local/bin/mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 640x480 -f 30 -q 80" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www -n"
ExecStop=/bin/kill $MAINPID

[Install]
WantedBy=multi-user.target
' | tee /etc/systemd/system/mjpg-streamer.service
```

```bash
apt-get install hostapd
apt-get install isc-dhcp-server
```

```bash
echo '
auto eth0
iface eth0 inet static
  address 192.168.5.200
  netmask 255.255.255.0
  gateway 192.168.5.1
  dns-nameservers 192.168.5.1

allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.10.1
  netmask 255.255.255.0
  broadcast 192.168.10.255
  network 192.168.10.0
' | tee /etc/network/interfaces
```

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

```bash
sed -i 's|^#DAEMON_CONF="/etc/hostapd.conf"|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd
```

```bash
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak

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

sed -i 's|^INTERFACES=""|INTERFACES="wlan0"|' /etc/default/isc-dhcp-server

sed -i 's|^#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo iptables -L -n -v

sh -c "iptables-save > /etc/iptables.ipv4.nat"

echo '
iptables-restore < /etc/iptables.ipv4.nat
exit 0
' | tee /etc/rc.local
```

```bash
sudo tee /usr/local/share/mjpg-streamer/www/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<style>
img {
  border: 5px solid #555;
}
</style>
</head>
<body onload="startTime()">
<h2>OptiLab Wifi Camera</h2>
<p id="demo"></p>
<div id="txt"></div>
<form>
  <label for="fname">No RM:</label>
  <input type="text" id="fname" name="fname"><br><br>
  <label for="fttl">Tgl lahir:</label>
  <input type="text" id="fttl" name="fttl"><br><br>
</form>
<img src="./?action=stream" />
<a href="./?action=snapshot" download>
<button> save image </button>
</a>
<script>
function startTime() {
  const today = new Date();
  let d = today.getDate();
  let mo = today.getMonth()+1;
  let y = today.getFullYear();
  let h = today.getHours();
  let m = today.getMinutes();
  let s = today.getSeconds();
  m = checkTime(m);
  s = checkTime(s);
  document.getElementById('txt').innerHTML = d + "-"+ mo + "-"+ y + " "+ h + ":" + m + ":" + s;
  setTimeout(startTime, 1000);
}

function checkTime(i) {
  if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
  return i;
}
</script>
</body>
</html>
EOF
```

```bash
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

systemctl start hostapd
systemctl enable hostapd

systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server

systemctl daemon-reload

systemctl start mjpg-streamer
systemctl restart mjpg-streamer
systemctl enable mjpg-streamer
systemctl status mjpg-streamer --no-pager -l
```

```bash
systemctl stop hostapd
systemctl disable hostapd

systemctl stop isc-dhcp-server
systemctl disable isc-dhcp-server

systemctl stop mjpg-streamer
systemctl disable mjpg-streamer

systemctl start NetworkManager.service
systemctl enable NetworkManager.service
```