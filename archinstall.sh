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


#################################################################
#                                                               #
#    __ _ _ __ ___| |__ (_)_ __  ___| |_ __ _| | |  ___| |__    #
#   / _` | '__/ __| '_ \| | '_ \/ __| __/ _` | | | / __| '_ \   #
#  | (_| | | | (__| | | | | | | \__ \ || (_| | | |_\__ \ | | |  #
#   \__,_|_|  \___|_| |_|_|_| |_|___/\__\__,_|_|_(_)___/_| |_|  #
#                                                               #
#################################################################


# Settings for the Script:

DELAY=0.5


# Greetings and settings

cat << EOF

#################################################################
#                                                               #
#                Arch Linux Installation Script                 #
#                                                               #
# archinstall  Copyright (C) 2019  xengineering                 #
# This program comes with ABSOLUTELY NO WARRANTY.               #
# This is free software, and you are welcome to redistribute it #
# under certain conditions. See                                 #
# <https://www.gnu.org/licenses/gpl-3.0.en.html> for details.   #
#                                                               #
#################################################################

EOF


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


# Check internet connection

TESTSERVER="8.8.8.8"  # hostnames will not work properly

if ping -w 1 -c 1 $TESTSERVER > /dev/null; then
    echo "Internet connection is ready - OK"
    echo ""
    sleep $DELAY
else
    echo "Could not reach testserver '$TESTSERVER' - FAILED"
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


# Install Base Packages

echo "Going to install base packages ..."
sleep $DELAY
echo ""
pacstrap /mnt base
echo ""
echo "Installed base packages - OK"
sleep $DELAY
echo ""


# Generate /etc/fstab file

genfstab -U /mnt >> /mnt/etc/fstab
echo "Generated /etc/fstab - OK"
sleep $DELAY
echo ""


# Deploy second Stage Script to new root

echo "Going to deploy second stage script for chroot environment ..."
sleep $DELAY
echo ""

cat > /mnt/root/secondstage.sh << EOL

# Set timezone

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "Timezone set - OK"
echo ""
sleep 1


# Localization - Greetings from Germany

echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE ISO-8859-1" >> /etc/locale.gen
echo "de_DE@euro ISO-8859-15" >> /etc/locale.gen

locale-gen

touch /etc/locale.conf
echo "LANG=de_DE.UTF-8" > /etc/locale.conf

touch /etc/vconsole.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

echo "German localization done - OK"
echo ""
sleep 1


# Network Configuration

touch /etc/hostname
echo $hostname > /etc/hostname

touch /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts

echo "Network configuration done - OK"
echo ""
sleep 1


# Initramfs

# implement if needed ...


# Set default Password

echo "root:root" | chpasswd
echo "Default password for user root set - OK"
echo ""
sleep 1


# Install Grub

pacman --noconfirm -Syu grub efibootmgr
mount $boot_partition_path /mnt
grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
umount $boot_partition_path
echo "Grub bootloader installed - OK"
echo ""
sleep 1

echo "Leaving chroot environment - OK"
echo ""
sleep 1

EOL

chmod 744 /mnt/root/secondstage.sh

echo "Second stage script deployed - OK"
echo ""
sleep 1


# Chroot to new System and launch second Stage

echo "Running second stage in chroot ..."
sleep $DELAY
echo ""
echo "/root/secondstage.sh" | arch-chroot /mnt


# Removing second Stage Script and umount the Root Partition

rm /mnt/root/secondstage.sh
umount $root_partition_path
echo "Removed second stage script and unmounted root partition - OK"
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
