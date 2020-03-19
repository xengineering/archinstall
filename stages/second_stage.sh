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


# debug output

printf "$OK Entering second_stage.sh\n"


# set timezone

ln -sf $path_to_timezone /etc/localtime
hwclock --systohc


# localization

echo "$locales_to_generate" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=$language" >> /etc/locale.conf
touch /etc/vconsole.conf
echo "KEYMAP=$keymap" >> /etc/vconsole.conf


# network configuration

touch /etc/hostname
echo "$hostname" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts


# initramfs

### to be implemented


# setting root password

echo "root:${DEFAULT_PASSWORD}" | chpasswd


# install bootloader

grub-install --target=i386-pc $path_to_disk
grub-mkconfig -o /boot/grub/grub.cfg
