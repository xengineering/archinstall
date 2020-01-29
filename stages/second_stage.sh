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


echo "Entering second_stage.sh - OK"


bash configure_keyboard.sh de-latin1

bash configure_locales.sh

bash configure_timezone.sh /usr/share/zoneinfo/Europe/Berlin

bash configure_network.sh $hostname

if [ $system_encryption == "yes" ]; then
    bash configure_initramfs.sh
fi

bash configure_users.sh $admin_username $DEFAULT_PASSWORD

bash install_bootloader.sh $efi_partition_path $system_encryption $main_partition_path

if [ "$desktop" = "yes" ]; then
    bash configure_desktop.sh $desktop
fi
