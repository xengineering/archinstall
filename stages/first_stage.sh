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


# Stop at any error to optimize debugging:

set -e


# Debug output

echo "Entering first_stage.sh - OK"


# Check bootmode

if [ -d "/sys/firmware/efi/efivars" ]; then
    export boot_mode="uefi"
    echo "Booted with UEFI"
else
    export boot_mode="bios"
    echo "Booted with legacy boot / BIOS"
fi


# Partition the disk

if [ "$boot_mode" == "unknown" ]; then
    echo "boot_mode unknown! - FAILED"
    exit 1
fi

if [ "$path_to_disk" == "/dev/null" ]; then
    echo "path_to_disk has still default value! - FAILED"
    exit 1
fi

if [ "$boot_mode" == "uefi" ]; then
    echo "Partitioning for UEFI mode."
    echo "Sorry, this is still untested and you should not try it ..."
    exit 1
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

    echo "Partitioned disk for UEFI/GPT- OK"
elif [ "$boot_mode" == "bios" ]; then
    echo "Partitioning for BIOS mode."
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

    echo "Partitioned disk for BIOS/MBR - OK"
else
    echo "Unknown boot_mode! - FAILED"
fi


# Format and mount partitions

if [ "$luks_encryption" == "no" ];then
    if [ "$boot_mode" == "bios" ];then
        echo "Formatting for no disk encryption and bios/mbr"
        mkfs.ext4 ${path_to_disk}1
        e2label ${path_to_disk}1 "boot"
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "root"
        mount ${path_to_disk}2 /mnt
        mkdir /mnt/boot
        mount ${path_to_disk}1 /mnt/boot
    elif [ "$boot_mode" == "uefi" ];then
        echo "Formatting for no disk encryption and uefi/gpt"
        ###
        echo "Sorry, UEFI is not ready to use ..."
        exit 1
    else
        echo "Unknown boot_mode! - FAILED"
        exit 1
    fi
elif [ "$luks_encryption" == "yes" ];then
    if [ "$boot_mode" == "bios" ];then
        echo "Formatting for disk encryption and bios/mbr"
        ###
        echo "Sorry, encryption is not ready to use ..."
        exit 1
    elif [ "$boot_mode" == "uefi" ];then
        echo "Formatting for disk encryption and uefi/gpt"
        ###
        echo "Sorry, encryption is not ready to use ..."
        exit 1
    else
        echo "Unknown boot_mode! - FAILED"
        exit 1
    fi
else
    echo "luks_encryption not 'yes' or 'no'! - FAILED"
    exit 1
fi


# Install packages with pacstrap

pacstrap /mnt $PACKAGE_LIST
echo "Installed packages - OK"


# Generate /etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
