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


mkdir $(dirname "$CONFIG_FILE_PATH")
touch $CONFIG_FILE_PATH
python write_config.py $CONFIG_FILE_PATH
disk=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "disk")
disk_path=/dev/$disk
hostname=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "hostname")
desktop=$(python $REPOSITORY_PATH/bin/get_config_string.py $CONFIG_FILE_PATH "desktop")


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

bash create_filesystems.sh $(disk_path)1 $(disk_path)2

bash mount_filesystems.sh $(disk_path)2
