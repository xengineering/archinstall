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

printf "$OK Entering first_stage.sh\n"


# check bootmode

if [ -d "/sys/firmware/efi/efivars" ]; then
    export boot_mode="uefi"
    printf "$OK Booted with UEFI\n"
else
    export boot_mode="bios"
    printf "$OK Booted with legacy boot / BIOS\n"
fi


# partition the disk

if [ "$path_to_disk" == "/dev/null" ]; then
    printf "$FAILED path_to_disk variable has still default value '/dev/null'\n"
    exit 1
fi

if [ "$boot_mode" == "uefi" ]; then
    printf "$OK Partitioning for UEFI mode ...\n"
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
    printf "$OK Partitioned disk for UEFI/GPT\n"

elif [ "$boot_mode" == "bios" ]; then
    printf "$OK Partitioning for BIOS mode ...\n"
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
    printf "$OK Partitioned disk for BIOS/MBR\n"

else
    printf "$FAILED Unknown boot_mode\n"
fi


# format and mount partitions

if [ "$luks_encryption" == "no" ];then
    if [ "$boot_mode" == "bios" ];then
        printf "$OK Formatting for no disk encryption and bios/mbr\n"
        mkfs.ext4 ${path_to_disk}1
        e2label ${path_to_disk}1 "boot"
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "root"
        mount ${path_to_disk}2 /mnt
        mkdir /mnt/boot
        mount ${path_to_disk}1 /mnt/boot
    elif [ "$boot_mode" == "uefi" ];then
        printf "$OK Formatting for no disk encryption and uefi/gpt\n"
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
        printf "$FAILED Unknown boot_mode\n"
        exit 1
    fi
elif [ "$luks_encryption" == "yes" ];then
    if [ "$boot_mode" == "bios" ];then
        printf "$OK Formatting for disk encryption and bios/mbr\n"
        ###
        printf "$FAILED Sorry, encryption is not ready to use ...\n"
        exit 1
    elif [ "$boot_mode" == "uefi" ];then
        printf "$OK Formatting for disk encryption and uefi/gpt\n"
        ###
        printf "$FAILED Sorry, encryption is not ready to use ...\n"
        exit 1
    else
        printf "$FAILED Unknown boot_mode\n"
        exit 1
    fi
else
    printf "$FAILED luks_encryption not 'yes' or 'no'\n"
    exit 1
fi


# install packages with pacstrap

pacstrap /mnt $PACKAGE_LIST
printf "$OK Installed packages\n"


# generate /etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
