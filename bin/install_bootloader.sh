#!/bin/bash


#  archinstall - A minimal Installation Script for Arch Linux
#  Copyright (C) 2019  xengineering

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.


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
