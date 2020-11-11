#!/usr/bin/env bash

# Cody Bunch
# blog.codybunch.com
# Adds the packer box to vagrant and runs vagrant up

Image="/home/bunchc/projects/packer-esxi/output/esxi67_x64"

if [ -e ${Image} ]; then
  echo "* Running virt-install for ${Image}"
  virt-install \
    --name test-packer-image \
    --ram=16384 \
    --vcpus=4 \
    --hvm \
    --virt-type=kvm \
    --disk=${Image},format=qcow2 \
    --network bridge=virbr0 \
    --vnc \
    --vncport=5900 \
    --vnclisten=0.0.0.0 \
    --keymap us \
    --noautoconsole \
    --noreboot \
    --import
else
  echo "Failed to find ${Image}"
  exit 1
fi

# Start the VM
echo "* Starting ${Image}"
virsh start test-packer-image

# Get the mac address from arp
until [[ ${MACADDR} != "" ]]; do
  echo "Checking ARP for vm..."
  MACADDR=$(arp -an | awk '/virbr0/ && /([[:xdigit:]]{2}[:.-]?){5}[[:xdigit:]]{2}/ { print $4 }')
  #MACADDR=$(arp -an | awk '/virbr0|^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$/ { print $4 }')
  sleep 5
done
echo "Found VM with MAC: ${MACADDR}"

# Wait for VM to get an IP
until [[ ${IPADDR} != "" ]]; do
  echo "Waiting for VM to get IP..."
  IPADDR=$(virsh net-dhcp-leases default | awk -v m="${MACADDR}" '$0~m {print $5}' | cut -d '/' -f 1)
  sleep 5
done
echo "VM has IP: ${IPADDR}"

until ssh root@${IPADDR} uptime; do
  echo "- Unable to connect, retrying..."
  sleep 5
done

#virsh destroy test-packer-image
#virsh undefine test-packer-image
