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


####################
#  first_stage.sh  #
####################


# Interview

echo "Here is a list of available hard disks on your computer:"
echo ""
lsblk -o NAME,SIZE,TYPE | grep -v part
echo ""
echo "Please type in the 'NAME' of the hard disk on which you want to"
echo "install Arch Linux:"
read disk
disk_path="/dev/$disk"
echo ""


echo "Please type in the hostname of your new machine:"
read hostname
echo ""


locales[1]="German / Germany"
cat << EOF
Please select one of the available localizations:

[1] ${locales[1]}
EOF
read locale_id
echo ""


cat << EOF
#################################################################

                            Summary

    Hard disk:     -  $disk
    Hostname:      -  $hostname
    Localization:  -  ${locales[$locale_id]}

#################################################################

EOF

echo "All data on disk '$disk' will be finally lost!"
echo "Are you SURE that you want to install Arch Linux to '$disk'?!"
echo "Type 'Yes' for installation and 'No' for abort."
read answer
if [ $answer == "Yes" ]; then
    echo ""
    echo "Starting installation process - OK"
    echo ""
else
    echo ""
    echo "Abort of installation process!"
    exit
fi


# Check if booted with UEFI

if [ -d "/sys/firmware/efi/efivars" ]; then
    echo "Booted with UEFI - OK"
    echo ""
    sleep $DELAY
else
    echo "Not booted with UEFI. Please enable it in your mainboard settings. - FAILED"
    exit
fi


# Update the system clock

timedatectl set-ntp true
if [ $? -eq 0 ]; then
    echo "Updated system clock - OK"
    echo ""
    sleep $DELAY
else
    echo "Could not update system clock - FAILED"
    exit
fi


# Partitioning

wipefs -a $disk_path > /dev/null  # make sure that fdisk does not ask for
                                  # removing signatures which breaks the script
fdisk $disk_path > /dev/null 2> /dev/null << EOF
g
n
1

+512M
n
2


p
w
EOF
boot_partition_path="${disk_path}1"
root_partition_path="${disk_path}2"
echo "Partitioning finished - OK"
sleep $DELAY
echo ""


# Create Filesystems

mkfs.fat -F32 $boot_partition_path > /dev/null 2> /dev/null
mkfs.ext4 $root_partition_path > /dev/null 2> /dev/null
fatlabel $boot_partition_path "BOOT" > /dev/null
e2label $root_partition_path "ROOT" > /dev/null
echo "Created filesystems - OK"
sleep $DELAY
echo ""


# Mount Root Filesystem

mount $root_partition_path /mnt
echo "Mounted root partition - OK"
sleep $DELAY
echo ""


# Install basic Packages

echo "Going to install basic packages ..."
sleep $DELAY
echo ""
pacstrap /mnt base linux linux-firmware dhcpcd
echo ""
echo "Installed basic packages - OK"
sleep $DELAY
echo ""


# Generate /etc/fstab file

genfstab -U /mnt >> /mnt/etc/fstab
echo "Generated /etc/fstab - OK"
sleep $DELAY
echo ""


# Launch second stage in chroot

echo "bash /opt/archinstall.git/bin/second_stage.sh $hostname ${disk_path}1" | arch-chroot /mnt


# Copy files from live image to root partition

cp -r $REPOSITORY_PATH /mnt$REPOSITORY_PATH
cp $LOG_FILE_PATH /mnt$LOG_FILE_PATH


# Unmount root partition

cd /root && umount $root_partition_path
echo "Unmounted root partition - OK"
sleep $DELAY
echo ""


# Final Messages

cat << EOF
#################################################################
#                                                               #
#     The default login is user root with password 'root'.      #
#     You can now power off your machine with 'poweroff',       #
#     remove the installation media and boot your new           #
#     Arch Linux machine!                                       #
#                                                               #
#################################################################

EOF
