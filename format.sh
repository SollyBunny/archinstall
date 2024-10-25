#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

clamp() {
	local value=$1
	local min=$2
	local max=$3

	if (( value < min )); then
		echo $min
	elif (( value > max )); then
		echo $max
	else
		echo $value
	fi
}

export DEV=/dev/sda
export DEVSIZE=$(blockdev --getsize64 $DEV)
export RAMSIZE=$(grep MemTotal /proc/meminfo | awk '{print $2}')
export SWAP=$(clamp $(($DEVSIZE / 8)) $((512 * 1024 * 1024)) $RAMSIZE)
echo $RAMSIZE $SWAP $DEVSIZE

echo "This formats the drive $DEV, make sure you are very sure. If not press ctrl-c"

read -r -n 1 -s

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $DEV
	g # new GPT partition table
	n # new partition
	# default partition number (1)
	# default start position
	+256M # 256 MB partition
	# accept wiping potential signature
	t # Set type
	uefi # UEFI boot partition
	n # new partition
	# partion number (2)
	# default start position
	+$SWAP # clamp(DEVSIZE / 8, 512MB, RAMSIZE)
	# accept wiping potential signature
	t # Set type
	2 # Of partition 2
	swap # Swap partition
	n # new partition
	# default partition number (1)
	# default start position
	# default end position (rest of disk)
	# accept wiping potential signature
	w # write to disk
	q # and we're done
EOF

read DEVBOOT DEVSWAP DEVLINUX <<< $(fdisk -l | grep -oE "^/dev/[^ ]+")

mkfs.fat -F32 $DEVBOOT
mkswap $DEVSWAP
mkfs.btrfs $DEVLINUX

mount $DEVLINUX /mnt/

pacstrap /mnt base linux linux-firmware btrfs-progs

mount $DEVBOOT /mnt/boot/efi
swapon $DEVSWAP

echo $DEVLINUX  /                       btrfs   rw,noatime,ssd,compress=zstd,discard=async,space_cache=v2,subvol=/ 0 1 > /mnt/etc/fstab
echo $DEVSWAP  none            swap    defaults 0 0 >> /mnt/etc/fstab
echo $DEVBOOT  /boot/efi       vfat    rw,noatime 0 2 >> /mnt/etc/fstab

arch-chroot /mnt