# OpenWrt Backup AP Failover

This repository contains scripts and configuration files for setting up a failover wireless access point (AP) using OpenWrt on a NanoPi R4S. The goal is to provide a backup wireless connection in case the primary Ubiquiti PoE access point goes down.

## Repository Structure

```
your-repo-name/
├── scripts/
│   └── wifi_failover.sh
├── config/
│   └── wireless_config
├── README.md
```

## Setup Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### 2. Configure Wireless Settings

Edit the `config/wireless_config` file and replace `'YourPasswordHere'` with your actual WiFi password.

### 3. Upload Wireless Configuration to OpenWrt

Copy the `wireless_config` file to your OpenWrt device and replace the existing wireless configuration.

```sh
scp config/wireless_config root@your-openwrt-device:/etc/config/wireless
ssh root@your-openwrt-device
uci commit wireless
wifi reload
```

### 4. Upload and Set Up the Failover Script

Copy the `wifi_failover.sh` script to your OpenWrt device, make it executable, and set it up to run at startup.

```sh
scp scripts/wifi_failover.sh root@your-openwrt-device:/root/
ssh root@your-openwrt-device
chmod +x /root/wifi_failover.sh

# Install required packages
opkg update
opkg install iputils-arping
opkg install kmod-mt7921u

# Add to startup
echo "/root/wifi_failover.sh &" >> /etc/rc.local
```

### 5. Reboot Your OpenWrt Device

Reboot your OpenWrt device to apply all changes.

```sh
reboot
```

## Customization

- **CHECK_INTERVAL:** Time in seconds between checks (default: 60).
- **FAIL_THRESHOLD:** Number of failed ARP checks before enabling backup AP (default: 3).
- **PRIMARY_AP_IP:** IP address of your primary AP.
- **PRIMARY_AP_MAC:** MAC address of your primary AP.

## Notes

- Ensure your NanoPi R4S has the necessary drivers for the EP-AX1672 AX3000 USB 3.0 WiFi Adapter.
- This setup assumes you have basic knowledge of OpenWrt and network configuration.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
