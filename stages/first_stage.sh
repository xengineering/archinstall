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

export disk=$(python $REPOSITORY_PATH/util/read_config_string.py $CONFIG_FILE_PATH "disk")
export disk_path=/dev/$disk
export efi_partition_path="${disk_path}1"
export boot_partition_path="${disk_path}2"
export main_partition_path="${disk_path}3"
export hostname=$(python $REPOSITORY_PATH/util/read_config_string.py $CONFIG_FILE_PATH "hostname")
export desktop=$(python $REPOSITORY_PATH/util/read_config_string.py $CONFIG_FILE_PATH "desktop")
export admin_username=$(python $REPOSITORY_PATH/util/read_config_string.py $CONFIG_FILE_PATH "admin_username")
export system_encryption=$(python $REPOSITORY_PATH/util/read_config_string.py $CONFIG_FILE_PATH "system_encryption")


bash confirm_installation.sh $disk

bash check_bootmode.sh

bash partition_disk.sh $disk_path

if [ $system_encryption == "yes" ];then

    bash format_crypto_partition.sh $main_partition_path $DEFAULT_PASSWORD

    bash open_crypto_partition.sh $main_partition_path $DEFAULT_PASSWORD

    bash setup_lvm.sh

    export main_partition_path="/dev/SystemVolumeGroup/root"

fi

bash create_filesystems.sh $efi_partition_path $main_partition_path

bash mount_filesystems.sh $main_partition_path

bash install_packages.sh $desktop

bash install_archinstall.sh $REPOSITORY_PATH

bash write_fstab.sh

echo "bash second_stage.sh" | arch-chroot /mnt

bash copy_archinstall_log.sh $LOG_FILE_PATH

bash unmount_filesystems.sh $main_partition_path

bash print_final_message.sh $DEFAULT_PASSWORD
