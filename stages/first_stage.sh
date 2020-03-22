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


# partition the disk

if [ "$path_to_disk" == "/dev/null" ]; then  # check if a disk is selected
    print_failed "path_to_disk variable has still default value '/dev/null'"
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

fi

print_ok "Partitioning done"


# format and mount partitions

if [ "$luks_encryption" == "no" ];then

    if [ "$boot_mode" == "bios" ];then

        print_ok "Formatting for no disk encryption and bios/mbr ..."

        # root partition
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "root"
        mount ${path_to_disk}2 /mnt

        # boot partition
        mkfs.ext4 ${path_to_disk}1
        e2label ${path_to_disk}1 "boot"
        mkdir /mnt/boot
        mount ${path_to_disk}1 /mnt/boot

    elif [ "$boot_mode" == "uefi" ];then

        print_ok "Formatting for no disk encryption and uefi/gpt ..."

        # root partition
        mkfs.ext4 ${path_to_disk}3
        e2label ${path_to_disk}3 "root"
        mount ${path_to_disk}3 /mnt

        # boot partition
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "boot"
        mkdir /mnt/boot
        mount ${path_to_disk}2 /mnt/boot

        # efi partition
        mkfs.fat -F32 ${path_to_disk}1
        fatlabel ${path_to_disk}1 "efi"
        mkdir /mnt/mnt
        mount ${path_to_disk}1 /mnt/mnt

    fi

elif [ "$luks_encryption" == "yes" ];then

    if [ "$boot_mode" == "bios" ];then

        print_ok "Formatting for disk encryption and bios/mbr ..."

        # root partition
        echo -n "$DEFAULT_PASSWORD" | cryptsetup luksFormat ${path_to_disk}2 -
        echo -n "$DEFAULT_PASSWORD" | cryptsetup open ${path_to_disk}2 main -
        mkfs.ext4 /dev/mapper/main
        e2label /dev/mapper/main "root"
        mount /dev/mapper/main /mnt

        # boot partition
        mkfs.ext4 ${path_to_disk}1
        e2label ${path_to_disk}1 "boot"
        mkdir /mnt/boot
        mount ${path_to_disk}1 /mnt/boot

    elif [ "$boot_mode" == "uefi" ];then

        print_ok "Formatting for disk encryption and uefi/gpt ..."

        # root partition
        echo -n "$DEFAULT_PASSWORD" | cryptsetup luksFormat ${path_to_disk}3 -
        echo -n "$DEFAULT_PASSWORD" | cryptsetup open ${path_to_disk}3 main -
        mkfs.ext4 /dev/mapper/main
        e2label /dev/mapper/main "root"
        mount /dev/mapper/main /mnt
        
        # boot partition
        mkfs.ext4 ${path_to_disk}2
        e2label ${path_to_disk}2 "boot"
        mkdir /mnt/boot
        mount ${path_to_disk}2 /mnt/boot

        # efi partition
        mkfs.fat -F32 ${path_to_disk}1
        fatlabel ${path_to_disk}1 "efi"
        mkdir /mnt/mnt
        mount ${path_to_disk}1 /mnt/mnt

    fi

fi

print_ok "Formatting done"


# optimize mirrorlist

print_ok "Optimize /etc/pacman.d/mirrorlist ..."
curl "https://www.archlinux.org/mirrorlist/?country=$pacman_mirror_region&protocol=http&protocol=https&ip_version=4" > /etc/pacman.d/mirrorlist
sed -i '/#Server = *./s/^#//g' /etc/pacman.d/mirrorlist
print_ok "/etc/pacman.d/mirrorlist optimized"


# install packages with pacstrap

print_ok "Installing Arch Linux packages with 'pacstrap' ..."
pacstrap /mnt $PACKAGE_LIST
print_ok "Installed packages"


# generate /etc/fstab

print_ok "Generating /etc/fstab ..."
genfstab -U /mnt >> /mnt/etc/fstab
print_ok "/etc/fstab generated"
