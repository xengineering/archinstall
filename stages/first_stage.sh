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


echo "Entering first_stage.sh - OK"


# Write config

mkdir $(dirname "$CONFIG_FILE_PATH")
touch $CONFIG_FILE_PATH
python $REPOSITORY_PATH/util/write_config.py $CONFIG_FILE_PATH


# Reading config values to bash

export disk=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "disk")
export disk_path=/dev/$disk
export boot_partition_path="${disk_path}1"
export root_partition_path="${disk_path}2"
export hostname=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "hostname")
export desktop=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "desktop")


# Confirmation

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


bash check_bootmode.sh

bash partition_disk.sh $disk_path

bash create_filesystems.sh $boot_partition_path $root_partition_path

bash mount_filesystems.sh $root_partition_path

bash install_packages.sh $desktop

bash install_archinstall.sh $REPOSITORY_PATH

bash write_fstab.sh

echo "bash second_stage.sh" | arch-chroot /mnt

bash copy_archinstall_log.sh $LOG_FILE_PATH

bash unmount_filesystems.sh $root_partition_path

bash print_final_message.sh
