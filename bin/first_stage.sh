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


# Argument Processing

DELAY=$1
REPOSITORY_PATH=$2
LOG_FILE_PATH=$3
CONFIG_FILE_PATH=$4


mkdir $(dirname "$CONFIG_FILE_PATH")
touch $CONFIG_FILE_PATH
python $2/bin/write_config.py $CONFIG_FILE_PATH
disk=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "disk")
disk_path=/dev/$disk
hostname=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "hostname")


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


# Partitioning

wipefs -a $disk_path  # make sure that fdisk does not ask for removing
                      # signatures which breaks the script
fdisk $disk_path << EOF
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

mkfs.fat -F32 $boot_partition_path
mkfs.ext4 $root_partition_path
fatlabel $boot_partition_path "BOOT"
e2label $root_partition_path "ROOT"
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


# Copy repository from live image to root partition

cp -r $REPOSITORY_PATH /mnt$REPOSITORY_PATH


# Generate /etc/fstab file

genfstab -U /mnt >> /mnt/etc/fstab
echo "Generated /etc/fstab - OK"
sleep $DELAY
echo ""


# Launch second stage in chroot

echo "bash $REPOSITORY_PATH/bin/second_stage.sh $hostname \
${disk_path}1 $REPOSITORY_PATH $CONFIG_FILE_PATH" | arch-chroot /mnt


# Copy log and config from live image to root partition

cp $LOG_FILE_PATH /mnt$LOG_FILE_PATH
mkdir /mnt$(dirname "$CONFIG_FILE_PATH")
cp $CONFIG_FILE_PATH /mnt$CONFIG_FILE_PATH


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
