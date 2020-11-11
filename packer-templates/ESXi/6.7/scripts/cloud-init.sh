#!/bin/sh

# local configuration options

# Note: modify at your own risk!  If you do/use anything in this
# script that is not part of a stable API (relying on files to be in
# specific places, specific tools, specific output, etc) there is a
# possibility you will end up with a broken system after patching or
# upgrading.  Changes are not supported unless under direction of
# VMware support.

# Note: This script will not be run when UEFI secure boot is enabled.
export PYTHONPATH="/opt/package:/opt/usr/lib/python3.5/site-packages"
cd /opt/usr/bin
python cloud-init -f /opt/etc/cloud/cloud.cfg init

exit 0