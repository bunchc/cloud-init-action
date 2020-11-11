echo -e "\n=== Start Pre-Freeze ==="

# Disable VSAN traffic if enabled & vmnic0
echo "Disabling vmnic0 ..."
esxcli vsan network remove -i vmk0
esxcli network nic down -n vmnic0

# Stop hostd
echo "Stopping hostd ..."
/etc/init.d/hostd stop

# Remove any exisitng VMkernel interfaces which would have associationg with existing MAC Addresses
echo "Removing vmk0 interface ..."
localcli network ip interface set -e false -i vmk0
localcli network ip interface remove -i vmk0
localcli network vswitch standard portgroup remove -p "Management Network" -v "vSwitch0"

# Ensure the new MAC Address is automatically picked up once cloned
#echo "Enable MAC Address updates ..."
#localcli system settings advanced set -o /Net/FollowHardwareMac -i 1

# Remove any potential old DHCP leases
echo "Clearing DHCP leases ..."
rm -f /etc/dhclient*leases

# Ensure new system UUID is generated
echo "Clearing UUID ..."
sed -i 's#/system/uuid.*##g' /etc/vmware/esx.conf

echo -e "=== End of Pre-Freeze ===\n"

#echo -e "\n=== Start Post-Freeze ==="
#
## Updating ESXi Host UUID
#echo "Updating ESXi Host UUID ..."
#vsish -e set /system/systemUuid ${UUIDHEX}
#echo "/system/uuid = \"${UUID}\"" >> /etc/vmware/esx.conf
#
## Updating VSAN Node UUID to match Host UUID
#echo "Updating VSAN Node UUID ..."
#localcli system settings advanced set -o /VSAN/NodeUuid -s ${UUID}
#
## setup vmk0
#echo "Configuring Management Network (vmk0) ..."
#localcli network nic up -n vmnic0
#localcli network vswitch standard portgroup add -p "Management Potato" -v "vSwitch0"
#localcli network ip interface add -i vmk0 -p "Management Potato"
#localcli network ip interface ipv4 set -i vmk0 -t dhcp
#localcli system hostname set -f packer-esxi
#
## Start hostd
#echo "Starting hostd ..."
#/etc/init.d/hostd start &
#
#echo "Wait for hostd to be ready & then rescan storage adapter ..."
## Ensure hostd is ready
#while ! vim-cmd hostsvc/hostsummary > /dev/null; do
#sleep 15
#done
#esxcli storage core adapter rescan -a
#esxcli vsan network ip add -i vmk0
#echo "=== End of Post-Freeze ==="
exit 0