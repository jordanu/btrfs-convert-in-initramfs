#!/bin/bash

set -ex

# Ensure that btrfs-convert, the binary, is included in the initramfs
sudo cp initramfs_hook.sh /etc/initramfs-tools/hooks/btrfs-convert-binary.sh

# Add our conversion script to the scripts run in the initramfs before the
# root FS is mounted
sudo cp premount_convert-to-btrfs.sh /etc/initramfs-tools/scripts/init-premount/convert-to-btrfs.sh

# Make sure the btrfs kernel module gets included in the initramfs
echo "btrfs" | sudo tee -a /etc/initramfs-tools/modules

# Switch ext4 to btrfs in entry for root fs in fstab
sudo sed -i 's/ext4/btrfs/' /etc/fstab

# Actually generate new initramfs with the above changes!
sudo update-initramfs -c -k all

# Get Ubuntu's secure boot tiny grub.cfg to seach by label (which will stay the
# same between the ext4 FS and the btrfs FS) instead of by filesystem UUID
# (which will change)
sudo sed -i 's/search.fs_uuid.*/search.fs_label cloudimg-rootfs root/' /boot/efi/EFI/ubuntu/grub.cfg

# Make grub's own search commands search by label, until the next time
# update-grub gets run, by which point it should correctly grab the UUID of the
# new btrfs filesystem as we want it to anyway.
sudo sed -i 's/--fs-uuid --set=root .*/--fs-label --set=root cloudimg-rootfs/' /boot/grub/grub.cfg

# Make the kernel parameter grub passess to the kernel use label rather than
# UUID
sudo sed -i 's/root=UUID=.* ro /root=LABEL=cloudimg-rootfs ro /' /boot/grub/grub.cfg
