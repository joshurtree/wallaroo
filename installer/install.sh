export iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
ROOT_MOUNT=/mnt/root
umount -A --recursive $ROOT_MOUNT

fdisk -l|grep ^Disk

while [[ ! -b $DISK ]]
do
    read -p "Enter disk to install Wallaroo on. (WARNING: All data currently on the disk will be lost!!!): " DISK
    if [[ ! -b $DISK ]]; then
        echo $DISK is not a valid device.
    fi
done

# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' ${DISK} # partition 1 (BIOS Boot Partition)
sgdisk -n 2::+300M --typecode=2:ef00 --change-name=2:'EFIBOOT' ${DISK} # partition 2 (UEFI Boot Partition)
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'ROOT' ${DISK} # partition 3 (Root), default start, remaining
if [[ ! -d "/sys/firmware/efi" ]]; then # Checking for bios system
    sgdisk -A 1:set:2 ${DISK}
fi
partprobe ${DISK} # reread partition table to ensure it is correct

mkfs.vfat -F32 -n "BOOT" ${DISK}2
mkfs.ext4 ${DISK}3

mount --mkdir ${DISK}3 ${ROOT_MOUNT}
mount --mkdir -t vfat ${DISK}2 ${ROOT_MOUNT}/boot

pacstrap ${ROOT_MOUNT} base linux linux-firmware dhcpcd grub podman distrobox --noconfirm --needed
genfstab -L ${ROOT_MOUNT} >> ${ROOT_MOUNT}/etc/fstab

arch-chroot ${ROOT_MOUNT}
