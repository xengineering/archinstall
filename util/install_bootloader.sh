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


efi_partition_path=$1
system_encryption=$2


############ Add encryption setting in /etc/default/grub before calling grub-mkconfig
## to generate /boot/grub/grub.cfg

## See: https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#Boot_loader


mount $efi_partition_path /mnt
grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=GRUB \
--removable

if [ $system_encryption == "yes" ];then

    cryptdevice_uuid=$(lsblk --fs | grep $main_partition_path | awk '{print $3}')
    echo "cryptdevice_uuid: $cryptdevice_uuid"
    old_kernel_param_line=$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT")
    echo "old_kernel_param_line: $old_kernel_param_line"
    new_kernal_param_line="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=UUID=${cryptdevice_uuid}:main root=/dev/mapper/main\""
    echo "new_kernel_param_line: $new_kernal_param_line"
    echo "Adding kernel parameters to /etc/default/grub"
    sed -i "s|$old_kernel_param_line|$new_kernal_param_line|" /etc/default/grub

fi

grub-mkconfig -o /boot/grub/grub.cfg
umount $efi_partition_path

echo "Installed bootloader - OK"
