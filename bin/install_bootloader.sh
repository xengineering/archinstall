

# Install Grub

pacman --noconfirm -Syu grub efibootmgr
mount $1 /mnt  # $1 = boot_partition_path
grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
umount $1
echo "Grub bootloader installed - OK"
echo ""
sleep 1

echo "Leaving chroot environment - OK"
echo ""
sleep 1
