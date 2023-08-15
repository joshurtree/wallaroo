echo Installing grub...
if [[ ! -d "/sys/firmware/efi" ]]; then
    grub-mkconfig -o ${ROOT_MOUNT}/boot/grub/grub.cfg
    grub-install --boot-directory=${ROOT_MOUNT}/boot ${DISK}
else
    pacstrap /mnt efibootmgr --noconfirm --needed
fi

