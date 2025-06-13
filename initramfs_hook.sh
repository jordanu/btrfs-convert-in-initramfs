#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

set -e
# Include btrfs-convert in our initramfs. For reasons!
# ( The reason being so that we can convert our root fs from ext4 to btrfs
# before it's actually mounted, avoiding the need for a LiveUSB or similar.

. /usr/share/initramfs-tools/hook-functions    #provides copy_exec
rm -f ${DESTDIR}/bin/btrfs-convert                   #copy_exec won't overwrite an existing file
copy_exec /usr/bin/btrfs-convert /bin/btrfs-convert        #Takes location in filesystem and location in initramfs as arguments
