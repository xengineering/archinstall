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


# stop at any error to optimize debugging:

set -e


# set timezone

print_ok "Setting timezone ..."
ln -sf $path_to_timezone /etc/localtime
hwclock --systohc
print_ok "Timezone set"


# localization

print_ok "Generating locales ..."
echo "$locales_to_generate" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=$language" >> /etc/locale.conf
touch /etc/vconsole.conf
echo "KEYMAP=$keymap" >> /etc/vconsole.conf
print_ok "Locales generated"


# network configuration

print_ok "Setting /etc/hostname and /etc/hosts file ..."
touch /etc/hostname
echo "$hostname" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
print_ok "/etc/hostname and /etc/hosts configured"


# initramfs

if [ "$luks_encryption" == "yes" ];then

    print_ok "Re-generating initramfs ..."

    old_hooks_config_line=$(cat /etc/mkinitcpio.conf | grep "^HOOKS=")
    print_ok "Old 'HOOKS' line in /etc/mkinitcpio : $old_hooks_config_line"
    new_hooks_config_line="HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)"
    print_ok "New 'HOOKS' line in /etc/mkinitcpio : $new_hooks_config_line"

    sed -i "s|$old_hooks_config_line|$new_hooks_config_line|" /etc/mkinitcpio.conf
    mkinitcpio -P

    print_ok "Initramfs re-generated"

fi


# setting root password

print_ok "Setting default password for user 'root' ..."
echo "root:${DEFAULT_PASSWORD}" | chpasswd
print_ok "Default password for user 'root' set"


# install and configure bootloader

print_ok "Installing grub bootloader ..."
if [ "$boot_mode" == "uefi" ]; then
    grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=GRUB \
    --removable
else
    grub-install --target=i386-pc $path_to_disk
fi
print_ok "Grub bootloader installed"

if [ $luks_encryption == "yes" ];then

    print_ok "Setup of /etc/default/grub for LUKS encryption ..."

    if [ "$boot_mode" == "uefi" ]; then
        crypto_partition="${path_to_disk}3"
    else
        crypto_partition="${path_to_disk}2"
    fi

    cryptdevice_uuid=$(lsblk --fs | grep "$(basename $crypto_partition)" | awk '{print $3}')
    print_ok "cryptdevice_uuid: $cryptdevice_uuid"
    old_kernel_param_line=$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT")
    print_ok "old_kernel_param_line: $old_kernel_param_line"
    new_kernal_param_line="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=UUID=${cryptdevice_uuid}:main root=/dev/mapper/main\""
    print_ok "new_kernel_param_line: $new_kernal_param_line"
    print_ok "Adding kernel parameters to /etc/default/grub ..."
    sed -i "s|$old_kernel_param_line|$new_kernal_param_line|" /etc/default/grub
    print_ok "Kernel parameters added to /etc/default/grub"

    print_ok "Setup of /etc/default/grub for LUKS encryption done"

fi

print_ok "Generating /boot/grub/grub.cfg from /etc/default/grub ..."
grub-mkconfig -o /boot/grub/grub.cfg
print_ok "/boot/grub/grub.cfg generated"
