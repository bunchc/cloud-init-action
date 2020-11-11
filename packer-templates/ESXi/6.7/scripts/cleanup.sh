#!/usr/bin/env bash

# Cody Bunch
# blog.codybunch.com
# Cleans up between builds

# Files and directories to clear out
declare -a CleanUpPaths=(
  'packer_cache/'
  'esxi67_x64-vagrant.box'
  'box.img'
  'output/'
)

# Cleanup
echo "Cleaning up from prior runs..."
echo "---"

echo "Killing test VM"
if ! virsh destroy test-packer-image; then
  echo "Unable to stop test VM"
elif ! virsh undefine test-packer-image; then
  echo "Unable to undefine test VM"
fi

echo "Removing files"
for CleanUpPath in ${CleanUpPaths[@]}; do
  if [ -e ${CleanUpPath} ]; then
    echo "* Removing ${CleanUpPath}"
    rm -rf ${CleanUpPath}
  fi
done

echo "Removing vagrant artifacts"
if ! virsh vol-delete esxi67_vagrant_box_image_0.img default; then
  echo "No image to delete"
fi
if ! vagrant box remove -f esxi67; then
  echo "No box to remove"
fi
