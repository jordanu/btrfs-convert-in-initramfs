#!/bin/bash

set -ex

# Ensure that btrfs-convert, the binary, is included in the initramfs
sudo cp initramfs_hook.sh /initramfs-tools/hooks/btrfs-convert-binary.sh

# Add our conversion script to the scripts run in the initramfs before the root FS is mounted
sudo cp premount_convert-to-btrfs.sh /initramfs-tools/scripts/init-premount/convert-to-btrfs.sh

# Make sure the btrfs kernel module gets included in the initramfs
echo "btrfs" | sudo tee -a /etc/initramfs-tools/modules

# Actually generate new initramfs with the above changes!
sudo update-initramfs -c -k all
