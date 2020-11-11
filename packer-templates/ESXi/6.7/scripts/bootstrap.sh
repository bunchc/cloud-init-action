#!/bin/sh

# Cody Bunch
# blog.codybunch.com
# ESXi 6.7 bootstrap script

set -x

# Allow the http client
echo -e "\n=== Open esx firewall: httpClient ==="
esxcli network firewall ruleset set -e true -r httpClient

# Install our ssh key
echo -e "\n=== Install SSH Key ==="
wget -O /tmp/bunchc.key https://github.com/bunchc.keys && cat /tmp/bunchc.key | tee -a /etc/ssh/keys-root/authorized_keys

# Install cloud-init
echo -e "\n=== Install cloud-init.vib ==="
esxcli --debug software vib install -v /vmfs/volumes/datastore1/cloud-init.vib -f

# Remove any potential old DHCP leases
echo "Clearing DHCP leases ..."
rm -f /etc/dhclient*leases

echo -e "\n=== Backup, then reset config ==="

localcli system settings advanced set -o /Net/FollowHardwareMac -i 1
sed -i 's#/system/uuid.*##' /etc/vmware/esx.conf
sed -i 's#/net/pnic/child\[....\]/mac.*##' /etc/vmware/esx.conf
sed -i 's#/net/vmkernelnic/child\[....\]/mac.*##' /etc/vmware/esx.conf

#sed -i '$d' /etc/rc.local.d/local.sh
#echo '
#echo -e "\n=== Start Post-Freeze ==="
#UUID=$(python -c "import uuid; print(uuid.uuid4())")
#UUIDHEX=$(python -c "import uuid; x = uuid.UUID('${UUID}'); print(x.bytes)")
#
## Updating ESXi Host UUID
#echo "Updating ESXi Host UUID ..."
#vsish -e set /system/systemUuid ${UUIDHEX}
#echo "/system/uuid = \"${UUID}\"" >> /etc/vmware/esx.conf
#
#localcli system hostname set -f packer-esxi
#exit 0
#' | tee -a /etc/rc.local.d/local.sh

/sbin/auto-backup.sh

#/sbin/firmwareConfig.sh --reset
