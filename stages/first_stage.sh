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

print_ok "Entering first_stage.sh"


# check bootmode

if [ -d "/sys/firmware/efi/efivars" ]; then
    export boot_mode="uefi"
    print_ok "Booted with UEFI"
else
    export boot_mode="bios"
    print_ok "Booted with legacy boot / BIOS"
fi


# partition the disk

if [ "$path_to_disk" == "/dev/null" ]; then
    print_failed "path_to_disk variable has still default value '/dev/null'"
    exit 1
fi

if [ "$boot_mode" == "uefi" ]; then
    print_ok "Partitioning for UEFI mode ..."
    wipefs -a $path_to_disk  # make sure that fdisk does not ask for removing
                             # signatures which breaks the script
    fdisk $path_to_disk << EOF
g
n
1

+512M
n
2

+200M
n
3


p
w
EOF
    print_ok "Partitioned disk for UEFI/GPT"

elif [ "$boot_mode" == "bios" ]; then
    print_ok "Partitioning for BIOS mode ..."
    wipefs -a $path_to_disk  # make sure that fdisk does not ask for removing
                             # signatures which breaks the script
    fdisk $path_to_disk << EOF
o
n
p
1

+200M
n
p
2


p
w
EOF
    print_ok "Partitioned disk for BIOS/MBR"

else
    print_failed "Unknown boot_mode"
fi


# format and mount partitions

if [ "$luks_encryption" == "no" ];then
    if [ "$boot_mode" == "bios" ];then
        print_ok "Formatting for no disk encryption and bios/mbr"
        mkfs.ext4 ${path_to_disk}1
        e2label ${path_to_disk}1 "boot"
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "root"
        mount ${path_to_disk}2 /mnt
        mkdir /mnt/boot
        mount ${path_to_disk}1 /mnt/boot
    elif [ "$boot_mode" == "uefi" ];then
        print_ok "Formatting for no disk encryption and uefi/gpt"
        mkfs.fat -F32 ${path_to_disk}1
        fatlabel ${path_to_disk}1 "efi"
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "boot"
        mkfs.ext4 ${path_to_disk}3
        e2label ${path_to_disk}3 "root"
        mount ${path_to_disk}3 /mnt
        mkdir /mnt/mnt
        mount ${path_to_disk}1 /mnt/mnt
        mkdir /mnt/boot
        mount ${path_to_disk}2 /mnt/boot
    else
        print_failed "Unknown boot_mode"
        exit 1
    fi
elif [ "$luks_encryption" == "yes" ];then
    if [ "$boot_mode" == "bios" ];then
        print_ok "Formatting for disk encryption and bios/mbr"
        ###
        print_failed "Sorry, encryption is not ready to use ..."
        exit 1
    elif [ "$boot_mode" == "uefi" ];then
        print_ok "Formatting for disk encryption and uefi/gpt"
        ###
        print_failed "Sorry, encryption is not ready to use ..."
        exit 1
    else
        print_failed "Unknown boot_mode"
        exit 1
    fi
else
    print_failed "luks_encryption not 'yes' or 'no'"
    exit 1
fi


# install packages with pacstrap

pacstrap /mnt $PACKAGE_LIST
print_ok "Installed packages"


# generate /etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
