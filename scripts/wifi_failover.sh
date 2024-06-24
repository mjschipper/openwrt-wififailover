#!/bin/sh

PRIMARY_AP_IP="192.168.1.2"  # IP address of your primary AP
PRIMARY_AP_MAC="00:00:00:00:00:00"  # MAC address of your primary AP
CHECK_INTERVAL=60  # Time in seconds between checks
FAIL_THRESHOLD=3  # Number of failed ARP checks before enabling backup

FAIL_COUNT=0

while true; do
    if arping -c 1 -I br-lan $PRIMARY_AP_IP | grep -q $PRIMARY_AP_MAC; then
        FAIL_COUNT=0
        # Disable the backup AP immediately when primary AP is back online
        uci set wireless.default_radio1.disabled='1'
        uci commit wireless
        wifi reload
        echo "Primary AP is up. Backup AP disabled."
    else
        FAIL_COUNT=$((FAIL_COUNT + 1))
        if [ $FAIL_COUNT -ge $FAIL_THRESHOLD ]; then
            uci set wireless.default_radio1.disabled='0'
            uci commit wireless
            wifi reload
            echo "Backup AP enabled."
            FAIL_COUNT=0  # Reset fail count after enabling backup AP
        fi
    fi
    sleep $CHECK_INTERVAL
done
