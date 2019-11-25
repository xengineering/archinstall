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


#####################
#  second_stage.sh  #
#####################


# Argument Processing

hostname=$1
boot_partition_path=$2
REPOSITORY_PATH=$3
CONFIG_FILE_PATH=$4
desktop=$5


# Localization

bash $REPOSITORY_PATH/bin/localization.sh


# Network Configuration

bash $REPOSITORY_PATH/bin/network_configuration.sh $hostname


# Initramfs

# implement if needed ...


# Set default Password

echo "root:root" | chpasswd
echo "Default password for user root set - OK"
echo ""
sleep 1


# Bootloader Installation

bash $REPOSITORY_PATH/bin/install_bootloader.sh $boot_partition_path


# Desktop Installation

if [ "$desktop" = "yes" ]; then
    bash $REPOSITORY_PATH/bin/install_desktop.sh
fi


# DHCP Setup

bash $REPOSITORY_PATH/bin/setup_dhcp.sh


# Good bye chroot

echo "Leaving chroot environment - OK"
echo ""
sleep 1
