#!/bin/bash
pkg update && pkg upgrade -y
pkg install git python nodejs hostapd dnsmasq iptables -y
pip install flask
chmod +x *.sh
echo "✅ Installed! Run ./run.sh"
