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


desktop_wanted=$1  # e.g. "yes"


pacstrap /mnt base linux linux-firmware dhcpcd nano sudo grub efibootmgr
if [ "$desktop_wanted" = "yes" ]; then
    pacstrap /mnt xorg lightdm lightdm-gtk-greeter light-locker accountsservice gnome-screensaver xfce4-pulseaudio-plugin network-manager-applet xfce4 mousepad
fi

echo "Installed packages - OK"
